require 'active_support/core_ext/object'
require "evernote_utils/array"
require "evernote_utils/filter"

module ENUtils
  class Note < Evernote::EDAM::Type::Note

    DEFAULT_LIMIT = 10

    # Evernote::EDAM::Type::Note fields
    #   guid:"f1df2a4d-5852-4cb6-82f7-6240ee4e2b5c"
    #   title:"Note title"
    #   contentHash:eeeeeeee6bxxxxxxxxxxxxxxxa889ca7
    #   contentLength:2246
    #   created:1266881336000
    #   updated:1266881347000
    #   active:true
    #   updateSequenceNum:2653
    #   notebookGuid:"4xxxxxda-xxxx-xxxx-xxxx-zzzzzzzzzzzz"
    #   attributes:<Evernote::EDAM::Type::NoteAttributes >

    attr_reader :guid, :title, :contentHash, :contentLength, :created, :updated, :active, :updateSequenceNum, :notebookGuid, :attributes

    def initialize(edam_note)
       @guid              = edam_note.guid
       @title             = edam_note.title
       @contentHash       = edam_note.contentHash
       @contentLength     = edam_note.contentLength
       @created           = Time.at(edam_note.created/1000)
       @updated           = Time.at(edam_note.updated/1000)
       @active            = edam_note.active
       @updateSequenceNum = edam_note.updateSequenceNum
       @notebookGuid      = edam_note.notebookGuid
       @attributes        = edam_note.attributes
    end

    def self.where(core, options={})
      offset = options.delete(:offset) || 0
      limit  = options.delete(:limit)  || DEFAULT_LIMIT
      result = core.notestore.findNotes(core.token, NoteFilter.build(options), offset, limit).notes.map{|n| new(n) }
      NoteList.new(core, result, options)
    end

  end
end
