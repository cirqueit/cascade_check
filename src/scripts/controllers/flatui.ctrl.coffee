do ->
    angular.module('flatuiApp.controllers')
        .controller('FlatUICtrl', ['$scope', '$http', ($scope, $http) ->

            $scope.total_images = 511
            $scope.min_neighbors = 3
            $scope.scale = 1.1
            $scope.hide_abstract = true

            $scope.data = []
            $scope.sliced = []

            $scope.ready = 0
            $scope.rows = 1
            $scope.columns = 2
            $scope.abstract = (img) ->
                true

            $scope.hide = ->
                if $scope.hide_abstract
                    $scope.hide_abstract = false
                else
                    $scope.hide_abstract = true

            $scope.grid = (columns) ->
                'col-md-' + (12/columns).toString()
            $scope.idx = 0
            $scope.show = 0

            $scope.colors = [
                ['#3498db', 'btn-info'],
                ['#1abc9c', 'btn-primary'],
                ['#2ecc71', 'btn-success'],
                ['#f1c40f', 'btn-warning'],
                ['#e74c3c', 'btn-danger'],
            ]

            $scope.log = (message) ->
                console.log(message)

            $scope.rate_tpr = (cascade) ->
                rate = $scope.rates.filter((e) -> e.cascade == cascade.name && e.min_neighbors == $scope.min_neighbors && e.scale == $scope.scale)[0]
                if $scope.hide_abstract
                    return rate.stpr.toString()[0...6]
                else
                    return rate.tpr.toString()[0...6]

            $scope.rate_fpr = (cascade) ->
                rate = $scope.rates.filter((e) -> e.cascade == cascade.name && e.min_neighbors == $scope.min_neighbors && e.scale == $scope.scale)[0]
                if $scope.hide_abstract
                    return rate.sfpr.toString()[0...6]
                else
                    return rate.fpr.toString()[0...6]

            $scope.rate_tp = (image) ->
                img = $scope.data.filter((e) -> e.name == image)[0]
                data = img[$scope.cascade.name].filter((e) -> e.scale == $scope.scale && e.min_neighbors == $scope.min_neighbors)[0]
                return data.tp

            $scope.rate_fp = (image) ->
                img = $scope.data.filter((e) -> e.name == image)[0]
                data = img[$scope.cascade.name].filter((e) -> e.scale == $scope.scale && e.min_neighbors == $scope.min_neighbors)[0]
                return data.fp

            $scope.button = (idx) ->
                $scope.colors[idx % $scope.colors.length][1]

            $scope.fill = (idx) ->
                $scope.colors[idx % $scope.colors.length][0]
                
            $scope.cascades = [
                    {'name': 'ocv haar', 'dic': {}, 'src': 'frontal_face_haar.json'},
                    {'name': 'ocv alt', 'dic': {}, 'src': 'frontal_face_haar_alt.json'},
                    {'name': 'ocv alt2','dic': {}, 'src': 'frontal_face_haar_alt2.json'},
                    {'name': 'ocv lbp',  'dic': {}, 'src': 'frontal_face.json'},
                    # {'name': 'lbp r0',  'dic': {}, 'src': 'w20_h99999_m3_p200000_n20000_f16_r2_s81.json'},
                    # {'name': 'lbp r1',  'dic': {}, 'src': 'w20_h99999_m3_p200000_n20000_f16_r2_s81.json'},
                    # {'name': 'lbp r1+6',  'dic': {}, 'src': 'w20_h99995_m3_p200000_n10000_f16_r_s21.json'},
                    # {'name': 'lbp r2b',  'dic': {}, 'src': 'w20_h99999_m3_p200000_n20000_f16_r2_s81.json'},
                    # {'name': 'lbp r28',  'dic': {}, 'src': 'w20_h99999_m3_p200000_n20000_f16_r2_s81.json'},
                    # {'name': 'lbp r28+',  'dic': {}, 'src': 'w20_h99999_m3_p200000_n20000_f16_r2_s81.json'},
                    # {'name': 'lbp r2',  'dic': {}, 'src': 'w20_h99999_m3_p200000_n20000_f16_r2_s81.json'},
                    # {'name': 'lbp r2 16',  'dic': {}, 'src': 'w20_h999_m3_p200000_n10000_f16_r2_s16.json'},
                    # {'name': 'lbp',  'dic': {}, 'src': 'w20_h9995_m3_p100000_n100000_s9.json'},
                    # {'name': 'lbp r',  'dic': {}, 'src': 'w20_h9995_m3_p100000_n100000_r_s9.json'},
                    # {'name': 'lbp r2',  'dic': {}, 'src': 'w20_h9995_m3_p100000_n100000_r2_s9.json'},
                    # {'name': 'lbp9',  'dic': {}, 'src': 'w20_h9999_m3_p100000_n100000_s9.json'},
                    # {'name': 'lbp9 r',  'dic': {}, 'src': 'w20_h9999_m3_p100000_n100000_r_s9.json'},
                    # {'name': 'lbp9 r2',  'dic': {}, 'src': 'w20_h9999_m3_p100000_n100000_r2_s9.json'},
                    # {'name': 'lbp99',  'dic': {}, 'src': 'w20_h99995_m3_p100000_n100000_s9.json'},
                    # {'name': 'lbp99 r',  'dic': {}, 'src': 'w20_h99995_m3_p100000_n100000_r_s9.json'},
                    # {'name': 'lbp99 r2',  'dic': {}, 'src': 'w20_h99995_m3_p100000_n100000_r2_s9.json'},
                    # {'name': 'lbp r29',  'dic': {}, 'src': 'w20_h9999_m3_p200000_n10000_f16_r2_s22.json'},
                    # {'name': 'lbp r29',  'dic': {}, 'src': 'w20_h9999_m3_p200000_n10000_f16_r2_s28.json'},
                    {'name': 'l10'},
                    {'name': 'l10 r'},
                    {'name': 'l10 r2'},
                    #{'name': 'l10 r2 s25'},
                    {'name': 'l8'},
                    {'name': 'l8 r'},
                    {'name': 'l8 r2'},
                    # {'name': 'pl10'},
                    # {'name': 'pl10 r'},
                    # {'name': 'pl10 r2'},
                    # {'name': 'pl8'},
                    # {'name': 'pl8 r'},
                    # {'name': 'pl8 r2'},
                    # {'name': 'pl8 r2'},
                    {'name': 'l8 r2 s32'},
            ]

            $scope.enter = (cascade) ->
                $scope.cascade = cascade
                $scope.show = 1

            $scope.leave = (cascade) ->
                $scope.show = 0

            $scope.opencv = (cascade) ->
                if cascade.name[0...3] == 'ocv'
                    return 'btn-inverse'
                else
                    return 'btn-info'
                
            $scope.load = (image) ->
                try
                    faces = $scope.data.filter((e) -> e.name == image)[0][$scope.cascade.name].filter((e) -> e.scale == $scope.scale && e.min_neighbors == $scope.min_neighbors)[0].faces
                catch
                    faces = []
                faces



            $scope.update = ->
                $scope.sliced = []
                for i in [0...$scope.rows]
                    start = $scope.idx + i * $scope.columns
                    end = start + $scope.columns
                    $scope.sliced.push($scope.data[start...end])

            $scope.inc = ->
                $scope.idx = $scope.idx + $scope.columns * $scope.rows
                if $scope.idx > $scope.data.length - 1
                    $scope.idx = $scope.data.length - 1
                $scope.update()

            $scope.dec = ->
                $scope.idx = $scope.idx - $scope.columns * $scope.rows
                if $scope.idx < 0
                    $scope.idx = 0
                $scope.update()

            $http.get('results/compared.json').success((data) ->
                    $scope.data = data
                    $scope.update()
                    $scope.ready = 1
            )
            $http.get('results/rates.json').success((data) ->
                    $scope.rates = data
            )
        ])
