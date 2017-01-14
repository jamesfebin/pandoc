{-# LANGUAGE DeriveDataTypeable, DeriveGeneric #-}
{-
Copyright (C) 2012-2016 John MacFarlane <jgm@berkeley.edu>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
-}

{- |
   Module      : Text.Pandoc.Extensions
   Copyright   : Copyright (C) 2012-2016 John MacFarlane
   License     : GNU GPL, version 2 or above

   Maintainer  : John MacFarlane <jgm@berkeley.edu>
   Stability   : alpha
   Portability : portable

Data structures and functions for representing markup extensions.
-}
module Text.Pandoc.Extensions ( Extension(..)
                              , Extensions
                              , emptyExtensions
                              , extensionsFromList
                              , extensionEnabled
                              , enableExtension
                              , disableExtension
                              , pandocExtensions
                              , plainExtensions
                              , strictExtensions
                              , phpMarkdownExtraExtensions
                              , githubMarkdownExtensions
                              , multimarkdownExtensions )
where
import Data.Word (Word64)
import Data.Bits (testBit, setBit, clearBit)
import Data.Data (Data)
import Data.Typeable (Typeable)
import GHC.Generics (Generic)

newtype Extensions = Extensions Word64
  deriving (Show, Read, Eq, Ord, Bounded, Data, Typeable, Generic)

extensionsFromList :: [Extension] -> Extensions
extensionsFromList = foldr enableExtension emptyExtensions

emptyExtensions :: Extensions
emptyExtensions = Extensions 0

extensionEnabled :: Extension -> Extensions -> Bool
extensionEnabled x (Extensions exts) = testBit exts (fromEnum x)

enableExtension :: Extension -> Extensions -> Extensions
enableExtension x (Extensions exts) = Extensions (setBit exts (fromEnum x))

disableExtension :: Extension -> Extensions -> Extensions
disableExtension x (Extensions exts) = Extensions (clearBit exts (fromEnum x))

-- | Individually selectable syntax extensions.
data Extension =
      Ext_footnotes           -- ^ Pandoc/PHP/MMD style footnotes
    | Ext_inline_notes        -- ^ Pandoc-style inline notes
    | Ext_pandoc_title_block  -- ^ Pandoc title block
    | Ext_yaml_metadata_block -- ^ YAML metadata block
    | Ext_mmd_title_block     -- ^ Multimarkdown metadata block
    | Ext_table_captions      -- ^ Pandoc-style table captions
    | Ext_implicit_figures    -- ^ A paragraph with just an image is a figure
    | Ext_simple_tables       -- ^ Pandoc-style simple tables
    | Ext_multiline_tables    -- ^ Pandoc-style multiline tables
    | Ext_grid_tables         -- ^ Grid tables (pandoc, reST)
    | Ext_pipe_tables         -- ^ Pipe tables (as in PHP markdown extra)
    | Ext_citations           -- ^ Pandoc/citeproc citations
    | Ext_raw_tex             -- ^ Allow raw TeX (other than math)
    | Ext_raw_html            -- ^ Allow raw HTML
    | Ext_tex_math_dollars    -- ^ TeX math between $..$ or $$..$$
    | Ext_tex_math_single_backslash  -- ^ TeX math btw \(..\) \[..\]
    | Ext_tex_math_double_backslash  -- ^ TeX math btw \\(..\\) \\[..\\]
    | Ext_latex_macros        -- ^ Parse LaTeX macro definitions (for math only)
    | Ext_fenced_code_blocks  -- ^ Parse fenced code blocks
    | Ext_fenced_code_attributes  -- ^ Allow attributes on fenced code blocks
    | Ext_backtick_code_blocks    -- ^ GitHub style ``` code blocks
    | Ext_inline_code_attributes  -- ^ Allow attributes on inline code
    | Ext_markdown_in_html_blocks -- ^ Interpret as markdown inside HTML blocks
    | Ext_native_divs             -- ^ Use Div blocks for contents of <div> tags
    | Ext_native_spans            -- ^ Use Span inlines for contents of <span>
    | Ext_bracketed_spans         -- ^ Bracketed spans with attributes
    | Ext_markdown_attribute      -- ^ Interpret text inside HTML as markdown
                                  --   iff container has attribute 'markdown'
    | Ext_escaped_line_breaks     -- ^ Treat a backslash at EOL as linebreak
    | Ext_link_attributes         -- ^ link and image attributes
    | Ext_mmd_link_attributes     -- ^ MMD style reference link attributes
    | Ext_autolink_bare_uris  -- ^ Make all absolute URIs into links
    | Ext_fancy_lists         -- ^ Enable fancy list numbers and delimiters
    | Ext_lists_without_preceding_blankline -- ^ Allow lists without preceding blank
    | Ext_startnum            -- ^ Make start number of ordered list significant
    | Ext_definition_lists    -- ^ Definition lists as in pandoc, mmd, php
    | Ext_compact_definition_lists  -- ^ Definition lists without
                               -- space between items, and disallow laziness
    | Ext_example_lists       -- ^ Markdown-style numbered examples
    | Ext_all_symbols_escapable  -- ^ Make all non-alphanumerics escapable
    | Ext_angle_brackets_escapable  -- ^ Make < and > escapable
    | Ext_intraword_underscores  -- ^ Treat underscore inside word as literal
    | Ext_blank_before_blockquote -- ^ Require blank line before a blockquote
    | Ext_blank_before_header     -- ^ Require blank line before a header
    | Ext_strikeout           -- ^ Strikeout using ~~this~~ syntax
    | Ext_superscript         -- ^ Superscript using ^this^ syntax
    | Ext_subscript           -- ^ Subscript using ~this~ syntax
    | Ext_hard_line_breaks    -- ^ All newlines become hard line breaks
    | Ext_ignore_line_breaks  -- ^ Newlines in paragraphs are ignored
    | Ext_east_asian_line_breaks  -- ^ Newlines in paragraphs are ignored between
                              -- East Asian wide characters
    | Ext_literate_haskell    -- ^ Enable literate Haskell conventions
    | Ext_abbreviations       -- ^ PHP markdown extra abbreviation definitions
    | Ext_emoji               -- ^ Support emoji like :smile:
    | Ext_auto_identifiers    -- ^ Automatic identifiers for headers
    | Ext_ascii_identifiers   -- ^ ascii-only identifiers for headers
    | Ext_header_attributes   -- ^ Explicit header attributes {#id .class k=v}
    | Ext_mmd_header_identifiers -- ^ Multimarkdown style header identifiers [myid]
    | Ext_implicit_header_references -- ^ Implicit reference links for headers
    | Ext_line_blocks         -- ^ RST style line blocks
    | Ext_epub_html_exts      -- ^ Recognise the EPUB extended version of HTML
    | Ext_shortcut_reference_links -- ^ Shortcut reference links
    deriving (Show, Read, Enum, Eq, Ord, Bounded, Data, Typeable, Generic)

pandocExtensions :: Extensions
pandocExtensions = extensionsFromList
  [ Ext_footnotes
  , Ext_inline_notes
  , Ext_pandoc_title_block
  , Ext_yaml_metadata_block
  , Ext_table_captions
  , Ext_implicit_figures
  , Ext_simple_tables
  , Ext_multiline_tables
  , Ext_grid_tables
  , Ext_pipe_tables
  , Ext_citations
  , Ext_raw_tex
  , Ext_raw_html
  , Ext_tex_math_dollars
  , Ext_latex_macros
  , Ext_fenced_code_blocks
  , Ext_fenced_code_attributes
  , Ext_backtick_code_blocks
  , Ext_inline_code_attributes
  , Ext_markdown_in_html_blocks
  , Ext_native_divs
  , Ext_native_spans
  , Ext_bracketed_spans
  , Ext_escaped_line_breaks
  , Ext_fancy_lists
  , Ext_startnum
  , Ext_definition_lists
  , Ext_example_lists
  , Ext_all_symbols_escapable
  , Ext_intraword_underscores
  , Ext_blank_before_blockquote
  , Ext_blank_before_header
  , Ext_strikeout
  , Ext_superscript
  , Ext_subscript
  , Ext_auto_identifiers
  , Ext_header_attributes
  , Ext_link_attributes
  , Ext_implicit_header_references
  , Ext_line_blocks
  , Ext_shortcut_reference_links
  ]

plainExtensions :: Extensions
plainExtensions = extensionsFromList
  [ Ext_table_captions
  , Ext_implicit_figures
  , Ext_simple_tables
  , Ext_multiline_tables
  , Ext_grid_tables
  , Ext_latex_macros
  , Ext_fancy_lists
  , Ext_startnum
  , Ext_definition_lists
  , Ext_example_lists
  , Ext_intraword_underscores
  , Ext_blank_before_blockquote
  , Ext_blank_before_header
  , Ext_strikeout
  ]

phpMarkdownExtraExtensions :: Extensions
phpMarkdownExtraExtensions = extensionsFromList
  [ Ext_footnotes
  , Ext_pipe_tables
  , Ext_raw_html
  , Ext_markdown_attribute
  , Ext_fenced_code_blocks
  , Ext_definition_lists
  , Ext_intraword_underscores
  , Ext_header_attributes
  , Ext_link_attributes
  , Ext_abbreviations
  , Ext_shortcut_reference_links
  ]

githubMarkdownExtensions :: Extensions
githubMarkdownExtensions = extensionsFromList
  [ Ext_angle_brackets_escapable
  , Ext_pipe_tables
  , Ext_raw_html
  , Ext_fenced_code_blocks
  , Ext_auto_identifiers
  , Ext_ascii_identifiers
  , Ext_backtick_code_blocks
  , Ext_autolink_bare_uris
  , Ext_intraword_underscores
  , Ext_strikeout
  , Ext_hard_line_breaks
  , Ext_emoji
  , Ext_lists_without_preceding_blankline
  , Ext_shortcut_reference_links
  ]

multimarkdownExtensions :: Extensions
multimarkdownExtensions = extensionsFromList
  [ Ext_pipe_tables
  , Ext_raw_html
  , Ext_markdown_attribute
  , Ext_mmd_link_attributes
  -- , Ext_raw_tex
  -- Note: MMD's raw TeX syntax requires raw TeX to be
  -- enclosed in HTML comment
  , Ext_tex_math_double_backslash
  , Ext_intraword_underscores
  , Ext_mmd_title_block
  , Ext_footnotes
  , Ext_definition_lists
  , Ext_all_symbols_escapable
  , Ext_implicit_header_references
  , Ext_auto_identifiers
  , Ext_mmd_header_identifiers
  , Ext_implicit_figures
  -- Note: MMD's syntax for superscripts and subscripts
  -- is a bit more permissive than pandoc's, allowing
  -- e^2 and a~1 instead of e^2^ and a~1~, so even with
  -- these options we don't have full support for MMD
  -- superscripts and subscripts, but there's no reason
  -- not to include these:
  , Ext_superscript
  , Ext_subscript
  ]

strictExtensions :: Extensions
strictExtensions = extensionsFromList
  [ Ext_raw_html
  , Ext_shortcut_reference_links
  ]

