Deface::Override.new(:virtual_path => "checkout/delivery",
                     :name => "add_contrassegno_instruction",
                     :insert_after => "#methods",
                     :partial => "shared/contrassegno_instructions",
                     :disabled => false)