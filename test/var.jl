using MiniOmega

function test_somwething()
  n = ~ finite(1:10)
  μ = [~ normal(0, 1) for i = 1:n]
  s = sum(μ)
end

function test_maximum_entropy()
  x = 1 ~ normal(0, 1)
  y = 2 ~ bounded(-4.0, 1.0)
  z(ω) = x(ω) + y(ω)

  # Find y which maximises entropy of x
  argmax(y, mean(z))
end

function test_polynomial()
  function polynomial(ω)
    n = finite(ω, 1:10)
    function (x)
      y = 0.0
      for i = 1:n
        y += ~ normal(ω, 0, 1) * x^i
      end
      y
    end
  end
end

function tets_appendscope(ω1 = sample(defΩ()))
  # @test !MiniOmega.hastag(ω1, Val{:scope})
  # @test !MiniOmega.hastag(ω1, :scope)
  ω2 = MiniOmega.appendscope(ω1, (1,))
  # @test MiniOmega.hastag(ω2, Val{:scope})
  ω3 = MiniOmega.rmscope(ω2)
  # @test !MiniOmega.hastag(ω3, Val{:scope})
end