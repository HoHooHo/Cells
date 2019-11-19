/******************************************************************************
*                                                                             *
*  Copyright (C) 2014 ZhangXiaoYi                                             *
*                                                                             *
*  @author   ZhangXiaoYi                                                      *
*  @date     2014-11-05                                                       *
*                                                                             *
*****************************************************************************/

#pragma once
#include <string>
#include <queue>
#include <mutex>
#include <unordered_map>
#include "../../Utils/CellMacro.h"

NS_CELL_BEGIN

template<typename T>
class CellQueue
{
private:
	std::queue<T> _queue ;
	std::mutex _queueMutex ;

public:
	typedef std::queue<T> _queue_t ;
	typedef typename _queue_t::value_type value_type ;
	typedef typename _queue_t::reference reference ;

	inline bool empty()
	{
		std::unique_lock<std::mutex> lock(_queueMutex) ;
		return _queue.empty() ;
	}

	inline void clear()
	{
		std::unique_lock<std::mutex> lock(_queueMutex) ;
		while ( !_queue.empty() )
		{
			_queue.pop() ;
		}
	}

	inline size_t size()
	{
		std::unique_lock<std::mutex> lock(_queueMutex) ;
		return _queue.size() ;
	}

	inline void push(const value_type& v)
	{
		std::unique_lock<std::mutex> lock(_queueMutex) ;
		_queue.push(v) ;
	}

	inline value_type pop()
	{
		std::unique_lock<std::mutex> lock(_queueMutex) ;

		value_type v = _queue.front() ;
		_queue.pop() ;

		return v ;
	}
};


template<typename K, typename V>
class CellMap
{
private:
	std::unordered_map<K, V> _map ;
	std::mutex _mapMutex ;

public:
	typedef std::unordered_map<K, V>		_map_t ;
	typedef typename _map_t::key_type		key_type ;
	typedef typename _map_t::mapped_type	mapped_type ;
	typedef typename _map_t::iterator		iterator ;
//	typedef typename _map_t::reverse_iterator	reverse_iterator;

	inline bool empty()
	{
		std::unique_lock<std::mutex> lock(_mapMutex) ;
		return _map.empty() ;
	}

	inline void clear()
	{
		std::unique_lock<std::mutex> lock(_mapMutex) ;
		_map.clear() ;
	}

	inline size_t size()
	{
		std::unique_lock<std::mutex> lock(_mapMutex) ;
		return _map.size() ;
	}

	inline iterator find(const key_type& k)
	{
		return _map.find(k);
	}

	inline iterator begin()
	{
		return _map.begin();
	}

	inline iterator end()
	{
		return _map.end();
	}

//	inline reverse_iterator rbegin()
//	{
//		return _map.rbegin();
//	}
//
//	inline reverse_iterator rend()
//	{
//		return _map.rend();
//	}

	inline void insert(const key_type& k, const mapped_type& v)
	{
		std::unique_lock<std::mutex> lock(_mapMutex) ;
		_map.insert(std::make_pair(k, v)) ;
	}

	void erase(const key_type& k)
	{
		std::unique_lock<std::mutex> lock(_mapMutex) ;
		_map.erase(k) ;
	}

	iterator erase(iterator i)
	{
		std::unique_lock<std::mutex> lock(_mapMutex) ;
		return _map.erase(i) ;
	}
};

NS_CELL_END