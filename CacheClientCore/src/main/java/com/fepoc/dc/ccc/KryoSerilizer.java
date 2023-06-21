package com.fepoc.dc.ccc;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.List;

import org.springframework.data.redis.serializer.RedisSerializer;
import org.springframework.data.redis.serializer.SerializationException;

import com.esotericsoftware.kryo.Kryo;
import com.esotericsoftware.kryo.io.Input;
import com.esotericsoftware.kryo.io.Output;

public class KryoSerilizer<T> implements RedisSerializer<T>{

	private Kryo kryo;

	public KryoSerilizer(List<Class<?>> classes) {
		kryo = new Kryo();
		classes.stream().forEach(a->kryo.register(a));
	}
	
	@Override
	public byte[] serialize(T t) throws SerializationException {
		try(ByteArrayOutputStream baos = new ByteArrayOutputStream()){
			Output output = new Output(baos);
			kryo.writeClassAndObject(output, t);
			output.close();
			return baos.toByteArray();
		} catch (IOException e) {
		}
		return null;
	}

	@SuppressWarnings("unchecked")
	@Override
	public T deserialize(byte[] bytes) throws SerializationException {
		return (T) kryo.readClassAndObject(new Input(bytes));
	}
	


}
