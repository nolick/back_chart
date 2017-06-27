// Run this example by adding <%= javascript_pack_tag 'hello_react' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>Hello React</div> at the bottom
// of the page.

import React from 'react'
import ReactDOM from 'react-dom'
import { render } from 'react-dom'
import PropTypes from 'prop-types'
import {BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend} from 'recharts';

class BackChart extends React.Component {
  constructor(props){
    super(props)
    this.state = {
      source: []
    };
  }

  componentDidMount(){
    this.fetchData()
  }

  fetchData(){
    fetch('http://localhost:3000/backlog_api/summaries.json', {
        mode: 'cors'})
    .then((response) => response.json())
    .then((responseData) => {
      this.setState({
        source: responseData
      })
    })
  }

  render(){
    return(
      <SimpleBarChart source={this.state.source}/>
    )
  }
}

class SimpleBarChart extends React.Component {
  render () {
    return (
        <div>
        <h1>計画: {this.props.source[0]}</h1>
        <h1>ベロシティ: {this.props.source[1]}</h1>
        <BarChart width={1500} height={800} data={this.props.source[2]}
          margin={{top: 5, right: 30, left: 500, bottom: 5}} layout='vertical'>
          <XAxis type="number"/>
          <YAxis type="category" dataKey="summary" fontSize="15"/>
          <CartesianGrid strokeDasharray="3 3"/>
          <Tooltip/>
          <Legend />
          <Bar dataKey="estimate" fill="#00E676" />
          <Bar dataKey="actual_hours" fill="#EEFF41" />
        </BarChart>
        </div>
    )
  }
}

render(
  <BackChart/>,
  document.getElementById('div')
 )
