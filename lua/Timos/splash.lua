local function printArt(art)
  for _,v in pairs(art) do
    vim.api.nvim_echo({{v, "MyArtColor"}}, true, {})
  end
end

-- This one is for catppuccin
-- vim.cmd("highlight MyArtColor guifg=#f9e2af")

-- This one is for nord
-- vim.cmd("highlight MyArtColor guifg=#81a1c1")

-- This one is for nordic
vim.cmd("highlight MyArtColor guifg=#ebcb8b")

local asciiArt1 = {
[[                                         ♬                                                     ♪                                                   ♫                                                                                       ]],
[[                                    ♩                                        ♫                                                                                       ♬                                                                     ]],
[[                                                       ♪                                                   ♬                                                                ♩                                                              ]],
[[                               ♫                                                                                          ♪                                                                 ♬                                             ]],
[[                                                                       ♫                                                                      ♩                                                          ♪                                ]],
[[                                                ♬                                                     ♪                                                                                                       ♩                           ]],
[[                                                                             ♬                                                                            ♪                                                                               ]],
[[                                                                       ♫                                                                      ♩                                                          ♪                                ]],
[[                                                                                                                                                                         ▒▒       ♪             ♫                                            ]],
[[                                                               ♬                                                               ♩                                       ▒▒    ░░         ♩                                                    ]],
[[                 ♫                                                                          ♫                                                     ♩              ░░    ▒▒                                                              ]],
[[                                         ♩                                                                                                                     ▒▒  ▒▒  ▓▓                   ♪                                           ]],
[[                                                                                                               ♫                                             ▒▒    ▒▒▒▒▒▒       ♫                                                      ]],
[[              ♬                              ▓▓▓▓           ♪                                                                  ♩                            ░░          ▒▒                           ♩                                  ]],
[[                                             ▓▓▓▓░░                                      ♫                                                                   ▒▒        ▓▓                                                              ]],
[[                            ♩              ▒▒▓▓▓▓▓▓▒▒                                                   ♩                                                          ▒▒             ♪                                                    ]],
[[                                            ▓▓▒▒░░▓▓▓▓                      ▒▒       ♬                                                 ♫                  ░░      ░░▒▒                                                                  ]],
[[                 ♪                          ▓▓    ▓▓▓▓                    ▒▒▒▒    ░░▒▒▒▒                        ░░                                      ░░░░  ░░    ▒▒          ♬                                                       ]],
[[                                           ▓▓    ▓▓▓▓▒▒                  ░░    ░░▒▒▒▒             ♪            ▒▒▒▒                              ░░▓▓                  ▒▒    ░░░░░░▒▒░░▒▒░░  ░░                                       ]],
[[                              ♫            ▓▓    ▓▓▓▓▓▓               ░░▒▒▒▒▒▒▒▒    ░░    ▒▒▒▒▒▒▒▒                                            ▓▓▒▒▓▓▓▓            ▒▒      ░░  ▒▒  ▒▒▒▒    ░░        ♪                                   ]],
[[                                            ▓▓    ▓▓▓▓▓▓          ░░▒▒  ░░    ▒▒▒▒▒▒                      ░░▒▒░░       ♩    ░░                    ▓▓▓▓▒▒▓▓▓▓▓▓  ▒▒            ▓▓    ▒▒    ░░                                           ]],
[[             ♬                              ▓▓    ▓▓▓▓    ▓▓░░░░      ▒▒▒▒                  ░░░░▒▒                  ▒▒░░░░░░░░                ▒▒      ▓▓▓▓▒▒▒▒▓▓▓▓▓▓▓▓      ▓▓            ░░                                           ]],
[[                                            ▒▒▓▓▓▓▓▓▓▓    ▒▒▒▒  ▒▒▒▒    ▒▒▒▒▒▒▒▒     ♪  ▓▓▓▓▓▓        ░░▒▒        ▒▒▒▒░░░░░░▒▒▒▒░░              ░░  ▒▒▒▒▒▒  ▓▓▓▓▓▓      ░░▒▒            ░░                                            ]],
[[                    ♩                         ▓▓▓▓▓▓▒▒░░    ▒▒          ▓▓▒▒  ▒▒        ▒▒██░░░░          ░░  ░░  ▒▒                    ▓▓▓▓░░                        ▒▒              ░░                  ♫                             ]],
[[                                            ▓▓▓▓▓▓░░░░  ░░  ░░    ░░         ♫              ▓▓    ░░            ░░▒▒        ▒▒▒▒  ▓▓▓▓▓▓  ▒▒░░▓▓              ▒▒      ░░░░      ░░                                                    ]],
[[                            ♪               ▓▓▓▓▓▓▒▒    ▒▒    ░░▒▒          ░░░░            ░░▓▓▓▓▓▓          ░░              ▒▒  ▒▒          ▓▓▓▓▓▓            ▒▒▓▓      ░░░░    ░░░░  ░░░░  ░░                                      ]],
[[                                            ▓▓▓▓▒▒░░  ▒▒    ░░        ░░    ▓▓▓▓        ▓▓▓▓▓▓▓▓▓▓  ░░░░          ░░░░    ▒▒▒▒        ░░▒▒▒▒  ▒▒░░░░▓▓██████           ♬  ░░    ░░    ░░░░░░  ░░                                      ]],
[[                       ♬                  ▓▓▓▓░░    ▓▓  ▓▓▓▓    ▒▒▒▒                    ▒▒    ▒▒          ░░░░  ░░▒▒    ░░▒▒░░                    ░░██████▒▒██████            ░░  ▒▒▒▒░░    ░░      ♪                                  ]],
[[                                          ▓▓▒▒    ░░▓▓▓▓▓▓▓▓▓▓▓▓  ░░        ▒▒▒▒▒▒░░    ▒▒  ▒▒▓▓▒▒  ▒▒        ▒▒▒▒▒▒          ░░▒▒▒▒                      ████████        ░░░░  ▒▒▒▒░░    ░░                                           ]],
[[                                  ♫       ▓▓    ░░▓▓▓▓▓▓    ▓▓▓▓▓▓░░▒▒▒▒▒▒              ♩           ▒▒▓▓      ░░░░  ░░          ▒▒▓▓░░                                ░░░░                ░░░░                                         ]],
[[                                        ▒▒▓▓  ░░  ▓▓    ▒▒░░  ▓▓▓▓▓▓▒▒                            ░░▓▓    ▒▒▒▒        ░░░░                ░░░░                    ░░                    ░░  ▒▒          ♬                               ]],
[[           ♪                            ▒▒▓▓▒▒    ▓▓    ▓▓    ▒▒▓▓  ▒▒    ░░▒▒          ▒▒▒▒▒▒▓▓▒▒▓▓▓▓        ▓▓          ░░░░              ▒▒              ░░                      ░░░░  ▒▒▒▒                                         ]],
[[                                          ▓▓      ▓▓░░░░    ▓▓  ▓▓    ▒▒░░▒▒▓▓          ▓▓▒▒▓▓▓▓       ♫          ▓▓          ░░▒▒          ▒▒▒▒                                  ▒▒      ▒▒░░  ░░     ♩                                ]],
[[                  ♩                       ▓▓▓▓░░  ░░▒▒    ▓▓  ▓▓▓▓                    ▒▒▒▒                            ▒▒        ▓▓░░        ░░▒▒▒▒                              ░░▒▒            ▓▓                                     ]],
[[                                            ▓▓  ░░      ▓▓▓▓░░▓▓                                                        ▓▓            ░░  ░░  ▒▒▒▒░░                        ░░░░  ▒▒░░        ░░▓▓                                     ]],
[[                           ♬                ▓▓▓▓▓▓░░▒▒▓▓▓▓▓▓                                                            ░░░░       ♪    ░░░░    ▒▒                    ░░░░      ▒▒          ▓▓                                        ]],
[[                                            ░░    ▓▓▓▓    ▓▓                                                                ▓▓                ░░░░░░            ░░░░                      ▓▓░░           ♪                             ]],
[[                                                           ♪                                                                                                                                                                      ]],
[[                                    ♩                                        ♫                                                                                       ♬                                                                     ]],
[[                                                       ♪                                                   ♬                                                                ♩                                                              ]],
[[                                                ♬                                                     ♪                                                                                                       ♩                           ]],
[[                                    ♩                                        ♫                                                                                       ♬                                                                     ]],
[[                               ♫                                                                                          ♪                                                                 ♬                                             ]],
[[                                                                       ♫                                                                      ♩                                                          ♪                                ]],
[[        ♪   ♫   ♬                                                                                                                                                                                                                  ]],
[[   ♩ ♪♫ ╦ ╦╔═╗╦  ╦  ╔═╗  ╔╦╗╦╔╦╗╔═╗╔═╗ ♫ ♪ ♩                                                                                                                                                                                      ]],
[[ ♬ ♩ ♫♫ ╠═╣║╣ ║  ║  ║ ║   ║ ║║║║║ ║╚═╗ ♫ ♪ ♬                                                                                                                                                                                      ]],
[[   ♩ ♪♫ ╩ ╩╚═╝╩═╝╩═╝╚═╝   ╩ ╩╩╩╩╚═╝╚═╝ ♫ ♪ ♩                                                                                                                                                                                      ]],
}
printArt(asciiArt1)
