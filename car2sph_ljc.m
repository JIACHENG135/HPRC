function characteristic_value=car2sph_ljc(N)
[TH,PHI,R] = cart2sph(N(:,1),N(:,2),N(:,3));
characteristic_value = TH .* 100 + PHI .* 10 + R;
end