function hash = sha256_file(path)
%SHA256_FILE Identificador de los bytes originales; requiere JVM de MATLAB.
fid = fopen(path,'rb');
assert(fid>=0,'No se pudo abrir %s.',path);
cleanup = onCleanup(@() fclose(fid));
md = java.security.MessageDigest.getInstance('SHA-256');
while ~feof(fid)
    md.update(fread(fid,1048576,'*uint8'));
end
bytes = typecast(md.digest(),'uint8');
hash = lower(reshape(dec2hex(bytes,2).',1,[]));
end

