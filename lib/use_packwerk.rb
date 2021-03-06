# typed: strict

# Ruby internal requires
require 'fileutils'

# External gem requires
require 'colorized_string'

# Internal gem requires
require 'parse_packwerk'
require 'code_teams'
require 'code_ownership'
require 'package_protections'

# Private implementation requires
require 'use_packwerk/private'
require 'use_packwerk/per_file_processor_interface'
require 'use_packwerk/rubocop_post_processor'
require 'use_packwerk/code_ownership_post_processor'
require 'use_packwerk/logging'
require 'use_packwerk/configuration'
require 'use_packwerk/cli'

module UsePackwerk
  extend T::Sig

  PERMITTED_PACK_LOCATIONS = T.let([
    'gems',
    'components',
    'packs',
  ], T::Array[String])

  sig do
    params(
      pack_name: String,
      enforce_privacy: T::Boolean,
      enforce_dependencies: T.nilable(T::Boolean)
    ).void
  end
  def self.create_pack!(
    pack_name:,
    enforce_privacy: true,
    enforce_dependencies: nil
  )
    Private.create_pack!(
      pack_name: pack_name,
      enforce_privacy: enforce_privacy,
      enforce_dependencies: enforce_dependencies, 
    )
  end

  sig do
    params(
      pack_name: String,
      paths_relative_to_root: T::Array[String],
      per_file_processors: T::Array[PerFileProcessorInterface],
    ).void
  end
  def self.move_to_pack!(
    pack_name:,
    paths_relative_to_root: [],
    per_file_processors: []
  )
    Private.move_to_pack!(
      pack_name: pack_name,
      paths_relative_to_root: paths_relative_to_root,
      per_file_processors: per_file_processors,
    )
  end

  sig do
    params(
      paths_relative_to_root: T::Array[String],
      per_file_processors: T::Array[PerFileProcessorInterface],
    ).void
  end
  def self.make_public!(
    paths_relative_to_root: [],
    per_file_processors: []
  )
    Private.make_public!(
      paths_relative_to_root: paths_relative_to_root,
      per_file_processors: per_file_processors
    )
  end

  sig do
    params(
      pack_name: String,
      dependency_name: String
    ).void
  end
  def self.add_dependency!(
    pack_name:,
    dependency_name:
  )
    Private.add_dependency!(
      pack_name: pack_name,
      dependency_name: dependency_name
    )
  end

  sig do
    params(
      pack_name: T.nilable(String),
      limit: Integer,
    ).void
  end
  def self.list_top_privacy_violations(
    pack_name:,
    limit:
  )
    Private::PackRelationshipAnalyzer.list_top_privacy_violations(
      pack_name,
      limit
    )
  end

  sig do
    params(
      pack_name: T.nilable(String),
      limit: Integer
    ).void
  end
  def self.list_top_dependency_violations(
    pack_name:,
    limit:
  )
    Private::PackRelationshipAnalyzer.list_top_dependency_violations(
      pack_name,
      limit
    )
  end

  sig do
    params(
      file: String,
      find: Pathname,
      replace_with: Pathname,
    ).void
  end
  def self.replace_in_file(file:, find:, replace_with:)
    Private.replace_in_file(
      file: file,
      find: find,
      replace_with: replace_with,
    )
  end
end
