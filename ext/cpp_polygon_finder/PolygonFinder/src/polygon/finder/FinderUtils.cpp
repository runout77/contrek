/*
 * FinderUtils.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include <iostream>
#include <string>
#include <vector>
#include "PolygonFinder.h"
#include "FinderUtils.h"
#include "optionparser.h"

void FinderUtils::sanitize_options(pf_Options& options, std::vector<std::string> *incoming_options) {
  std::vector<char*> argv0;
  for (const auto& arg : *incoming_options)
  argv0.push_back(const_cast<char*>(arg.data()));
  argv0.push_back(nullptr);
  char** argv = &argv0[0];
  int argc = argv0.size() -1;

  enum  optionIndex { COMPRESS_UNIQ, VERSUS, COMPRESS_VISVALINGAM, COMPRESS_LINEAR, NUMBER_OF_TILES, COMPRESS_VISVALINGAM_TOLERANCE, TREEMAP, NAMED_SEQUENCES, BOUNDS, CONNECTIVITY};
  const option::Descriptor usage[] = {
     //  {UNKNOWN, 0,"" , ""    ,option::Arg::None, 0},
     {COMPRESS_VISVALINGAM, 0, "" , "compress_visvalingam", option::Arg::None, 0},
     {COMPRESS_LINEAR, 0, "" , "compress_linear", option::Arg::None, 0},
     {COMPRESS_VISVALINGAM_TOLERANCE, 0, "" , "compress_visvalingam_tolerance", option::Arg::Optional, 0},
     {COMPRESS_UNIQ, 0, "", "compress_uniq", option::Arg::None, 0},
     {NUMBER_OF_TILES, 0, "", "number_of_tiles", option::Arg::Optional, 0},
     {TREEMAP, 0, "", "treemap", option::Arg::None, 0},
     {NAMED_SEQUENCES, 0, "", "named_sequences", option::Arg::None, 0},
     {BOUNDS, 0, "", "bounds", option::Arg::None, 0},
     {VERSUS, 0, "v", "versus", option::Arg::Optional, 0},
     {CONNECTIVITY, 0, "c", "connectivity", option::Arg::Optional, 0},
     {0, 0, 0, 0, 0, 0}
  };

  option::Stats  stats(usage, argc, argv);
  option::Option ioptions[stats.options_max], buffer[stats.buffer_max];
  option::Parser parse(usage, argc, argv, ioptions, buffer);

  if (parse.error())  return;
  // VERSUS
  if (ioptions[VERSUS].count() > 0)
  { for (option::Option* opt = ioptions[VERSUS]; opt; opt = opt->next())
    { std::string opts = opt->arg;
      options.versus = (opts.compare("a") == 0 ? Node::A : Node::O);
      break;
    }
  }
  // COMPRESS UNIQ
  if (ioptions[COMPRESS_UNIQ].count() > 0)
  { options.compress_uniq = true;
  }
  // NUMBER_OF_TILES
  if (ioptions[NUMBER_OF_TILES].count() > 0)
  { try {
      options.number_of_tiles = std::stoi(ioptions[NUMBER_OF_TILES].arg);
      if (options.number_of_tiles <= 0) options.number_of_tiles = 1;
    }
    catch (const std::invalid_argument&) {
      std::cerr << "Errore: --number_of_tiles requires a number\n";
    }
  }
  // CONNECTIVITY
  if (ioptions[CONNECTIVITY].count() > 0)
  { try {
      if (std::stoi(ioptions[CONNECTIVITY].arg) == 8) options.connectivity_offset = 1;
    }
    catch (const std::invalid_argument&) {
      std::cerr << "Errore: --connectivity requires a number\n";
    }
  }
  // TREEMAP
  if (ioptions[TREEMAP].count() > 0)
  { options.treemap = true;
  }
  // NAMED_SEQUENCES
  if (ioptions[NAMED_SEQUENCES].count() > 0)
  { options.named_sequences = true;
  }
  // BOUNDS
  if (ioptions[BOUNDS].count() > 0)
  { options.bounds = true;
  }
  // COMPRESS LINEAR
  if (ioptions[COMPRESS_LINEAR].count() > 0)
  { options.compress_linear = true;
  }
  // COMPRESS UNIQ
  if (ioptions[COMPRESS_VISVALINGAM].count() > 0)
  { options.compress_visvalingam = true;
  }
  if (ioptions[COMPRESS_VISVALINGAM_TOLERANCE].count() > 0)
  { options.compress_visvalingam = true;
    for (option::Option* opt = ioptions[COMPRESS_VISVALINGAM_TOLERANCE]; opt; opt = opt->next())
    { std::string opts = opt->arg;
      options.compress_visvalingam_tolerance = strtof(opt->arg, 0);
      break;
    }
  }
  /*std::cout << "-----------" << std::endl;
  std::cout << "versus " << options.versus << std::endl;
  std::cout << "number_of_tiles " << options.number_of_tiles << std::endl;
  std::cout << "uniq " << options.compress_uniq << std::endl;
  std::cout << "linear " << options.compress_linear << std::endl;
  std::cout << "visvalingam " << options.compress_visvalingam << std::endl;
  std::cout << options.compress_visvalingam_tolerance << std::endl;
  std::cout << "-----------" << std::endl;*/
}
