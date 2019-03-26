import numpy as np
import scipy.stats as stats
import pylab as pl
import matplotlib.pyplot as pyplot
from flask import send_file, Flask, request, jsonify
app = Flask(__name__)

@app.route('/simple_statistics', methods=['POST'])
def simple_statistics():
    filename = 'myfig.png'
    content = request.get_json()
    sorted_input = sorted([y for [x, y, z] in content['data']])
    fit = stats.norm.pdf(sorted_input, np.mean(sorted_input), np.std(sorted_input))
    pl.plot(sorted_input, fit, '-o')
    pl.xlabel("Time in seconds")
    pl.hist(sorted_input, normed=True)
    pl.savefig(filename)
    return send_file(filename, mimetype='image/png')
