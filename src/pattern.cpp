#include "pattern.h"
#include <sstream>
#include <vector>

using namespace std;

struct ParseError {};

Pattern *parse_pattern(istringstream &);

Pattern *Pattern::parse(string input) {
  istringstream ss(input);
  return parse_pattern(ss);
}

template <typename P, typename T>
void replace_back(vector<P> ps, T func) {
  auto p = ps.back();
  ps.pop_back();
  ps.push_back(func(p));
}

Pattern *parse_pattern(istringstream &in) {
  vector<Pattern *> ps;

  for (;;) {
    switch (in.peek()) {
    case '(':
      in.get();
      ps.push_back(parse_pattern(in));
      if (in.get() != ')') {
        throw new ParseError();
      }
      break;
    case '|':
      in.get();
      replace_back(ps, [&](auto p) { return either(p, parse_pattern(in); });
      break;
    case '?':
      in.get();
      replace_back(ps, [&](auto p) { return repeat(ps.back(), 0, 1); });
      break;
    case '*':
      in.get();
      replace_back(ps, [&](auto p) { return repeat(ps.back(), 0); });
      break;
    case '+':
      in.get();
      replace_back(ps, [&](auto p) { return repeat(ps.back(), 1); });
      break;
    case '{':
      in.get();
      int min = 0;
      int max = -1;
      if (in.peek() != ',') {
        in >> min;
      }
      if (in.get() != ',') {
        throw new ParseError();
      }
      if (in.peek() != '}') {
        in >> max;
      }
      if (in.get() != '}') {
        throw new ParseError();
      }
      replace_back(ps, [&](auto p) { return repeat(ps.back(), min, max); });
      break;
    case EOF:
      return concat(ps);
      break;
    case ')': // fallthrough
    case '}': // fallthrough
    case ']': // fallthrough
      throw new ParseError();
    case '\'':
      in.get();
    // fallthrough

    default:
      ps.push_back(literal(in.get()));
    }
  }
}
