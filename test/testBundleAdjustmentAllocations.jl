if VERSION ≥ VersionNumber(1, 7, 3)
  @testset "residual allocations" begin
    df = problems_df()
    filter_df = df[(df.name .== "problem-49-7776-pre"), :]
    name, group = get_first_name_and_group(filter_df)
    model = BundleAdjustmentModel(name, group)
    r = typeof(model.meta.x0)(undef, model.nls_meta.nequ)

    residual!(model, model.meta.x0, r)
    residual_alloc(model, r) = @allocated residual!(model, model.meta.x0, r)
    @test residual_alloc(model, r) == 0
  end

  @testset "jac_structure allocations" begin
    df = problems_df()
    filter_df = df[(df.name .== "problem-49-7776-pre"), :]
    name, group = get_first_name_and_group(filter_df)
    model = BundleAdjustmentModel(name, group)

    jac_structure!(model, model.rows, model.cols)
    jac_structure_alloc(model) = @allocated jac_structure!(model, model.rows, model.cols)
    @test jac_structure_alloc(model) == 0
  end

  @testset "jac_coord allocations" begin
    df = problems_df()
    filter_df = df[(df.name .== "problem-49-7776-pre"), :]
    name, group = get_first_name_and_group(filter_df)
    model = BundleAdjustmentModel(name, group)

    jac_coord!(model, model.meta.x0, model.vals)
    jac_coord_alloc(model) = @allocated jac_coord!(model, model.meta.x0, model.vals)
    @test jac_coord_alloc(model) == 0
  end
end