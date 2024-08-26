# FdicAsDataframe

Up to date remote economic data access for ruby, using Polars dataframes. 

This package will fetch call report data (from US banks) from the Federal Financial Institutions Examination Council (FFIEC), and return the results as a Polars Dataframe. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ffiec_as_dataframe'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install ffiec_as_dataframe

## Usage

With no arguments provided in the initialization call, the gem will fetch the most recent call report data, and return it as a Polars dataframe.  Note that most of the column names correspond to 8 character abbreviations that are documented at https://www.federalreserve.gov/apps/mdrm/data-dictionary .  As requirements have changed over time, the number of columns will change with each release of the call report data.

```{ruby}
3.1.2 :003 > x = FfiecAsDataframe::CallReport.new.fetch
 => 
shape: (4_594, 3_817)                                                                             
...                                                                                               
3.1.2 :004 > x
 => 
shape: (4_594, 3_817)                                                                             
┌─────────┬─────────────────────────┬────────────────────┬───────────────────┬───┬──────────┬──────────┬──────────┬──────────┐
│ IDRSSD  ┆ FDIC Certificate Number ┆ OCC Charter Number ┆ OTS Docket Number ┆ … ┆ RCONFT15 ┆ RCONFT16 ┆ RCONHK18 ┆ RCONHK19 │
│ ---     ┆ ---                     ┆ ---                ┆ ---               ┆   ┆ ---      ┆ ---      ┆ ---      ┆ ---      │
│ i64     ┆ i64                     ┆ i64                ┆ i64               ┆   ┆ str      ┆ str      ┆ str      ┆ str      │
╞═════════╪═════════════════════════╪════════════════════╪═══════════════════╪═══╪══════════╪══════════╪══════════╪══════════╡
│ 37      ┆ 10057                   ┆ 0                  ┆ 16553             ┆ … ┆          ┆ false    ┆          ┆          │
│ 242     ┆ 3850                    ┆ 0                  ┆ 0                 ┆ … ┆          ┆ false    ┆          ┆          │
│ 279     ┆ 28868                   ┆ 0                  ┆ 2523              ┆ … ┆          ┆ false    ┆          ┆          │
│ 354     ┆ 14083                   ┆ 0                  ┆ 0                 ┆ … ┆          ┆ false    ┆          ┆          │
│ 457     ┆ 10202                   ┆ 0                  ┆ 0                 ┆ … ┆          ┆ false    ┆          ┆          │
│ …       ┆ …                       ┆ …                  ┆ …                 ┆ … ┆ …        ┆ …        ┆ …        ┆ …        │
│ 5805817 ┆ 59337                   ┆ 25237              ┆ 0                 ┆ … ┆          ┆ false    ┆          ┆          │
│ 5807400 ┆ 59326                   ┆ 0                  ┆ 0                 ┆ … ┆          ┆ false    ┆          ┆          │
│ 5859511 ┆ 59344                   ┆ 25288              ┆ 0                 ┆ … ┆          ┆ false    ┆          ┆          │
│ 5860740 ┆ 59305                   ┆ 0                  ┆ 0                 ┆ … ┆          ┆ false    ┆          ┆          │
│ 5887420 ┆ 59357                   ┆ 25302              ┆ 0                 ┆ … ┆          ┆          ┆          ┆          │
└─────────┴─────────────────────────┴────────────────────┴───────────────────┴───┴──────────┴──────────┴──────────┴──────────┘ 
```

A specific vintage of call report data can be fetched by specifying the "dt" argument in the initialization call.

```{ruby}
3.1.2 :005 > x = FfiecAsDataframe::CallReport.new(dt= '2022-12-31'.to_date).fetch
 => 
shape: (4_756, 3_992)                                                                             
...      
3.1.2 :006 > x = FfiecAsDataframe::CallReport.new(dt= '2023-12-31'.to_date).fetch
 => 
shape: (4_641, 3_923)                                                                             
...                                                                                               
3.1.2 :007 > x
 => 
shape: (4_641, 3_923)                                                                             
┌─────────┬─────────────────────────┬────────────────────┬───────────────────┬───┬──────────┬──────────┬──────────┬──────────┐
│ IDRSSD  ┆ FDIC Certificate Number ┆ OCC Charter Number ┆ OTS Docket Number ┆ … ┆ RCONFT15 ┆ RCONFT16 ┆ RCONHK18 ┆ RCONHK19 │
│ ---     ┆ ---                     ┆ ---                ┆ ---               ┆   ┆ ---      ┆ ---      ┆ ---      ┆ ---      │
│ i64     ┆ i64                     ┆ i64                ┆ i64               ┆   ┆ str      ┆ str      ┆ str      ┆ str      │
╞═════════╪═════════════════════════╪════════════════════╪═══════════════════╪═══╪══════════╪══════════╪══════════╪══════════╡
│ 37      ┆ 10057                   ┆ 0                  ┆ 16553             ┆ … ┆          ┆ false    ┆          ┆          │
│ 242     ┆ 3850                    ┆ 0                  ┆ 0                 ┆ … ┆          ┆ false    ┆          ┆          │
│ 279     ┆ 28868                   ┆ 0                  ┆ 2523              ┆ … ┆          ┆ false    ┆          ┆          │
│ 354     ┆ 14083                   ┆ 0                  ┆ 0                 ┆ … ┆          ┆ false    ┆          ┆          │
│ 457     ┆ 10202                   ┆ 0                  ┆ 0                 ┆ … ┆          ┆ false    ┆          ┆          │
│ …       ┆ …                       ┆ …                  ┆ …                 ┆ … ┆ …        ┆ …        ┆ …        ┆ …        │
│ 5805479 ┆ 59346                   ┆ 25287              ┆ 0                 ┆ … ┆          ┆ false    ┆          ┆          │
│ 5805488 ┆ 59349                   ┆ 25275              ┆ 0                 ┆ … ┆          ┆          ┆          ┆          │
│ 5805817 ┆ 59337                   ┆ 25237              ┆ 0                 ┆ … ┆          ┆ false    ┆          ┆          │
│ 5859511 ┆ 59344                   ┆ 25288              ┆ 0                 ┆ … ┆          ┆ false    ┆          ┆          │
│ 5860740 ┆ 59305                   ┆ 0                  ┆ 0                 ┆ … ┆          ┆ false    ┆          ┆          │
└─────────┴─────────────────────────┴────────────────────┴───────────────────┴───┴──────────┴──────────┴──────────┴──────────┘ 
```

Additionally, a single table (which may be contained in one or more parts) may be fetched using the "tbl" argument to the "new" call.  Note that, as in the following example, the "tbl" argument must contain the entire table mnemonic; here we fetched only the "RC" table, despite there being many other tables that also have a mnemonic that starts with "RC".

```{ruby}
3.1.2 :009 > x = FfiecAsDataframe::CallReport.new(dt= '2022-12-31'.to_date, tbl = 'RC').fetch
 => 
shape: (4_757, 80)                                                                                
...                                                                                               
3.1.2 :010 > x
 => 
shape: (4_757, 80)                                                                                
┌─────────┬──────────────────────────┬─────────────────────┬────────────────────┬───┬──────────────────┬─────────────────┬─────────────────────────────────┬──────────────────┐
│ IDRSSD  ┆ RCFD0071                 ┆ RCFD0081            ┆ RCFD1773           ┆ … ┆ RCONB995         ┆ RCONG105        ┆ RCONJA22                        ┆ RCONJJ34         │
│ ---     ┆ ---                      ┆ ---                 ┆ ---                ┆   ┆ ---              ┆ ---             ┆ ---                             ┆ ---              │
│ i64     ┆ str                      ┆ str                 ┆ str                ┆   ┆ str              ┆ str             ┆ str                             ┆ str              │
╞═════════╪══════════════════════════╪═════════════════════╪════════════════════╪═══╪══════════════════╪═════════════════╪═════════════════════════════════╪══════════════════╡
│ 0       ┆ INT-BEARING BALS DUE FRM ┆ NONINTEREST-BEARING ┆ AVAILABLE-FOR-SALE ┆ … ┆ SECURS SOLD UNDR ┆ TOT EQT CAP INC ┆ Equity securities with readily… ┆ Held to maturity │
│         ┆ DEP I…                   ┆ BALS&CURR&…         ┆ SECURITIES         ┆   ┆ AGRMNTS TO RE…   ┆ NONCTRL MINORI… ┆                                 ┆ securities (A…   │
│ 37      ┆                          ┆                     ┆                    ┆ … ┆ 0                ┆ 10868           ┆ 0                               ┆ 0                │
│ 242     ┆                          ┆                     ┆                    ┆ … ┆ 0                ┆ 2963            ┆ 0                               ┆ 0                │
│ 279     ┆                          ┆                     ┆                    ┆ … ┆ 0                ┆ 42160           ┆ 0                               ┆ 27827            │
│ 354     ┆                          ┆                     ┆                    ┆ … ┆ 0                ┆ 7366            ┆ 0                               ┆ 0                │
│ …       ┆ …                        ┆ …                   ┆ …                  ┆ … ┆ …                ┆ …               ┆ …                               ┆ …                │
│ 5760439 ┆                          ┆                     ┆                    ┆ … ┆ 0                ┆ 35637           ┆ 0                               ┆ 0                │
│ 5760662 ┆                          ┆                     ┆                    ┆ … ┆ 0                ┆ 29627           ┆ 44                              ┆ 40196            │
│ 5784921 ┆                          ┆                     ┆                    ┆ … ┆ 0                ┆ 12247           ┆ 0                               ┆ 0                │
│ 5787418 ┆                          ┆                     ┆                    ┆ … ┆ 0                ┆ 21542           ┆ 0                               ┆ 9917             │
│ 5788705 ┆                          ┆                     ┆                    ┆ … ┆ 0                ┆ 28250           ┆ 0                               ┆ 0                │
└─────────┴──────────────────────────┴─────────────────────┴────────────────────┴───┴──────────────────┴─────────────────┴─────────────────────────────────┴──────────────────┘ 
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/ffiec_as_dataframe. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/ffiec_as_dataframe/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the FdicAsDataframe project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/ffiec_as_dataframe/blob/main/CODE_OF_CONDUCT.md).
