%syllabal groups (with one marking)

VowelA=[1 4 7 10 13 15 18 21 24 27 30 33 35 39 41 45 48 52 55];
VowelE=[2 5 8 11 14 16 19 22 25 28 31 34 36 40 42 46 49 53 56];
VowelU=[3 6 9 12 17 20 23 26 29 32 37 38 43 44 47 50 51 54 57];
ConsBilabial=[1 2 3 21 22 23 27 28 29];
ConsLabiodental=[7 8 9 45 46 47];
ConsCoronal=[4 5 6 18 19 20 24 25 30 21 32 33 34 38 39:44 55 56 57];
ConsVelar=[10:12 15:17];
ConsGlottal=[13 14 50];

ConsVar{1}=ConsBilabial;
ConsVar{2}=ConsLabiodental;
ConsVar{3}=ConsCoronal;
ConsVar{4}=ConsVelar;
ConsVar{5}=ConsGlottal;


VowelVar{1}=VowelA;
VowelVar{2}=VowelE;
VowelVar{3}=VowelU;

i=1;
for m=1:3
    for n=1:5
        SylSet{i}=setdiff(VowelVar{m},setdiff(VowelVar{m},ConsVar{n}));
        i=i+1;
    end
end


for i=1:5
    segmented_ecog_cut{i}=segmented_ecog.data{i}
end


segmented_ecog_cut{1}=segmented_ecog.data{5}
segmented_ecog_cut{2}=segmented_ecog.data{10}
segmented_ecog_cut{3}=segmented_ecog.data{15}


%syllable groups for multiple markings
set1_consOnset=[1:3:171];%all labels at onset of consonant
set2_vowelOnset=[2:3:171];%all labels at onset of vowel
set3_end=[3:3:171];%all labels at end of syallable

%Makes cell array, each cell with indices of corresponding consonant type--
%contains only labels at obset of consonant
ConsOnsetGroups{1}=set1_consOnset(ConsBilabial);
ConsOnsetGroups{2}=set1_consOnset(ConsLabiodental);
ConsOnsetGroups{3}=set1_consOnset(ConsCoronal);
ConsOnsetGroups{4}=set1_consOnset(ConsVelar);
ConsOnsetGroups{5}=set1_consOnset(ConsGlottal);

%Makes cell array, each cell with indices of corresponding vowel type--
%contains only labels at obset of consonant
ConsOnsetGroups_vowels{1}=set1_consOnset(VowelA);
ConsOnsetGroups_vowels{2}=set1_consOnset(VowelE);
ConsOnsetGroups_vowels{3}=set1_consOnset(VowelU);

%Makes cell array, with all combinations of vowel and consonant types
%Includes only labels at the begining of consonant
i=1;
for m=1:3
    for n=1:5
        SylSet{i}=setdiff(VowelOnsetGroups{m},setdiff(VowelOnsetGroups{m},ConsOnsetGroups{n}));
        i=i+1;
    end
end




segmented_ecog_groupVowels{1}=cat(3,segmented_ecog_2blocks{1},segmented_ecog_2blocks{6},segmented_ecog_2blocks{11})
segmented_ecog_groupVowels{1}=cat(3,segmented_ecog_2blocks{1},segmented_ecog_2blocks{6},segmented_ecog_2blocks{11})
segmented_ecog_groupVowels{1}=cat(3,segmented_ecog_2blocks{1},segmented_ecog_2blocks{6},segmented_ecog_2blocks{11})
segmented_ecog_groupVowels{1}=cat(3,segmented_ecog_2blocks{1},segmented_ecog_2blocks{6},segmented_ecog_2blocks{11})
segmented_ecog_groupVowels{1}=cat(3,segmented_ecog_2blocks{1},segmented_ecog_2blocks{6},segmented_ecog_2blocks{11})