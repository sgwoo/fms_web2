<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,acar.common.*,acar.user_mng.*"%>
<jsp:useBean id="bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>
<%
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String content_code = "OFF_DOC";
	String content_seq  = "pension";
	//String content_seq  = "pension";
	String seq_send="";
	
 	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();		
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	var popObj = null;


	function MM_openBrWindow(theURL,winName,features) { //v2.0
	
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
	     
		theURL = "https://fms3.amazoncar.co.kr/data/doc/"+theURL;
		
		popObj = window.open('',winName,features);
		popObj.location = theURL
		popObj.focus();
		
	}
	//스캔등록
	function scan_reg(){
		window.open("reg_pension_scan.jsp", "SCAN", "left=10, top=10, width=720, height=400, scrollbars=yes, status=yes, resizable=yes");
	}
	
	
	function setbgcolor(o) {
    o.parentNode.parentNode.style.backgroundColor==o.checked?'#454454':'';
    if( o.checked){
    	o.parentNode.style.backgroundColor= 'rgb(153, 51, 51)';
    	}
    	else{
    		o.parentNode.parentNode.style.backgroundColor= '#454454';
    		}

}
	
	
//-->
</script>
</head>

<body leftmargin="15">
	<form name="form1" method="POST">
		<input type="hidden" name="user_id" value="<%=user_id%>">
		<input type="hidden" name="send_seq" value="test">
		<div class="navigation">
			<span class="style1">인사관리 > 사규관리  > 퇴직연금제도규약</span><span class="style5"></span>
		</div>
		<div class="content">
			<div style="float:right">				
				<input type="button" class="button" value="등록" onclick="javascript:scan_reg();"/>
			</div>
			<br/>
			<table class="inner-table">
				<colgroup>
					<col width="5%"/>
					<col width="*"/>
					<col width="15%"/>
					<col width="15%"/>
				</colgroup>	
				<thead>
			   		<tr>
			   			<th>연번</th>
			   			<th>구분</th>
			   			<th>종류</th>
			   			<%if(nm_db.getWorkAuthUser("임원",user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("총무팀",user_id)){%>	
							<th>삭제</th>
						<%}%>			   			
			   		</tr>
			   	</thead>
			   	<tbody>
			<%
			  	Map<String, String> map = new HashMap<String, String>();
	       
		       	for(int k=0;k<attach_vt_size;k++){
		        	 Hashtable ht = (Hashtable)attach_vt.elementAt(k);
		        	 String ht_string = ht.get("FILE_NAME")+"";
		        	 ht_string=ht_string.substring(0,ht_string.lastIndexOf("."));
		        	 if(map.get(ht_string)==null){
		        		 map.put(ht_string, k+"");
		        	 }else{
		        		map.put(ht_string, map.get(ht_string)+","+k);		
		        	 }
	        	}
		       	
		       TreeMap<String,String> tm = new TreeMap<String,String>(map);
		       Iterator<String> iteratorKey = tm.keySet().iterator();
	       
		       int doc_count=0;
		       
		       while(iteratorKey.hasNext()){
		           doc_count++;
		           String map_key = iteratorKey.next();
		           String[] map_result =  map.get(map_key).split(",");
				
		           for(int k=0;k<map_result.length;k++){
		               Hashtable ht = (Hashtable)attach_vt.elementAt(Integer.parseInt(map_result[k]));
		               String sfile_type = ht.get("FILE_NAME")+"";
		               sfile_type = sfile_type.substring(sfile_type.lastIndexOf(".")+1,sfile_type.length());
		               
		               if(k==0){
		        %>
						<tr>
							<td align="center"><%=doc_count%></td>
							<td>
								<%
								  String sfile_name = ht.get("FILE_NAME")+"";
								  sfile_name = sfile_name.substring(0,sfile_name.lastIndexOf("."));
								%>
								<%=sfile_name%>
							</td>
							
							<%if(ht.get("FILE_TYPE").equals("image/jpeg")||ht.get("FILE_TYPE").equals("image/pjpeg")||ht.get("FILE_TYPE").equals("application/pdf")){%>
							<td align="center">
								<input type="checkbox" name="ch_l_cd" value="<%=ht.get("SEQ")%>">
								<a href="javascript:openPopF('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기'>
									<img src="/acar/images/center/icon_<%=sfile_type%>.gif" align=absmiddle border="0">
								</a>
							<%}else{%>
							<td align="center">
								<input type="checkbox" name="ch_l_cd" value="<%=ht.get("SEQ")%>">
								<a href="https://fms3.amazoncar.co.kr/fms2/attach/download.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'>
									<img src="/acar/images/center/icon_<%=sfile_type%>.gif" align=absmiddle border="0">
								</a>
							<%}%>
					<%}else{%>
						<input type="checkbox" name="ch_l_cd" value="<%=ht.get("SEQ")%>">
							<%if(ht.get("FILE_TYPE").equals("image/jpeg")||ht.get("FILE_TYPE").equals("image/pjpeg")||ht.get("FILE_TYPE").equals("application/pdf")){%>
								<a href="javascript:openPopF('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기'>
									<img src="/acar/images/center/icon_<%=sfile_type%>.gif" align=absmiddle border="0">
								</a>
							<%}else{%>
								<a href="https://fms3.amazoncar.co.kr/fms2/attach/download.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'>
									<img src="/acar/images/center/icon_<%=sfile_type%>.gif" align=absmiddle border="0">
								</a>
							<%}%> 
					<%}
			  		 	if((k+1)==map_result.length){%> <%}%> <%}%> <%
							for(int k=0;k<map_result.length;k++){
			  		 			Hashtable ht = (Hashtable)attach_vt.elementAt(Integer.parseInt(map_result[k]));
			  		 			if(nm_db.getWorkAuthUser("임원",user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("총무팀",user_id)){
			  		 											if(k==0){%>
			  		 		</td>
							<td align="center">
								<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'>
									<img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0">
								</a>
							<%}else{%> 
								<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'>
									<img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0">
								</a>
							<%}
			  		 	if((k+1)==map_result.length){%>
			  		 		</td>
						</tr>
	
						<%}
			  		 }
				}			
			}
	       %>
	       		</tbody>
			</table>
		</div>
	</form>
</body>
</html>