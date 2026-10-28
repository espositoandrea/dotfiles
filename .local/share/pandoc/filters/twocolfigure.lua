-- Allows to make a figure two-columns wide by having
-- {starred=true} attribute.
--
-- source: https://github.com/jgm/pandoc/issues/9268#issuecomment-1864282920

if FORMAT:match 'latex' then
   function Figure (elem)
      local starred = elem.content[1].content[1].attributes['starred']
      if starred == "true" then
         return {
            pandoc.RawInline('latex', '\\begingroup\n\\RenewEnvironmentCopy{figure}{figure*}'),
            elem,
            pandoc.RawInline('latex', '\\endgroup')
         }
      else
         return elem
      end
   end
end

