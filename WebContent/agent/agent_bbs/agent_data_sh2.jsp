<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*,acar.util.*,acar.user_mng.*,acar.common.*"%>
<%@ include file="/agent/cookies.jsp" %>

<%
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	String gubun 	= request.getParameter("gubun")==null?"c_year":request.getParameter("gubun");
	String gubun1 	= request.getParameter("gubun1")==null?"8":request.getParameter("gubun1");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	
	
	String content_code = "OFF_DOC";
	String content_seq  = "docs3";
	
 	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();		
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	var popObj = null;
	
	function MM_openBrWindow2(theURL,winName,features) { //v2.0
		theURL = "https://fms3.amazoncar.co.kr/data/doc/"+theURL;
		window.open(theURL,winName,features);
	}
	
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
	//선택메일발송
	function select_email(){
		form1.send_seq.value="";
		var fm =document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];	
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == true){
					cnt++;
					if(cnt==1){
						form1.send_seq.value+=ck.value;
					}
					else{
						form1.send_seq.value+=","+ck.value;
					}

					//idnum=ck.value
				}
			}
		}			
		if(cnt == 0){
		 	alert("업무서식을 선택하세요.");
			return;
		}	
		
		fm.target = "_blank";
		fm.action = "http://fms1.amazoncar.co.kr/fms2/off_doc/select_mail_input_docs.jsp";
		fm.submit();	

	}		
//-->
</script>
</head>
<body>
	<form name="form1" method="POST">
	<input type="hidden" name="send_seq" value="test">
	<input type='hidden' name='user_id' value='<%=user_id%>'>
	<input type='hidden' name='br_id' 	value='<%=br_id%>'>
	<input type='hidden' name='sh_height' value='<%=sh_height%>'>
	<input type='hidden' name="s_width" value="<%=s_width%>">   
    <input type='hidden' name="s_height" value="<%=s_height%>">  
    <input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>">  
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle border=0>&nbsp;<span class=style1>Agent > <span class=style5>영업팀 업무서식</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
				
				<tr>
          <td colspan="3 "align='right' >

          <a href="javascript:select_email();"><img src=/acar/images/center/button_send_smail.gif align=absmiddle border=0></a>
                		
          </td>
        </tr>
			</table>
		</td>
	</tr>
	<tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
	  <td class='line'>
		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
		  <tr>
			<td class='title' width='100'>연번</td>
			<td class='title' width='700'>구분</td>
			<td class='title' width='100'>종류</td>			
		  </tr>
	  
		  <%
		  	Map<String, String> map = new HashMap<String, String>();
       
       	for(int k=0;k<attach_vt_size;k++){
        	 Hashtable ht = (Hashtable)attach_vt.elementAt(k);
        	 String ht_string =ht.get("FILE_NAME")+"";
        	 ht_string=ht_string.substring(0,ht_string.lastIndexOf("."));
        	 if(ht_string.contains("신차인수지")){
	        	 if(map.get(ht_string)==null){
	        		 map.put(ht_string, k+"");
	        	 }else{
	        			map.put(ht_string, map.get(ht_string)+","+k);
	        				
	        	 }
        	 }
        	  
        }
       TreeMap<String,String> tm = new TreeMap<String,String>(map);
       Iterator<String> iteratorKey = tm.keySet().iterator();
       
		  	int doc_count=0;
		  		  while(iteratorKey.hasNext()){
		  		 	doc_count++;
		  		  String map_key = iteratorKey.next();
		  		 			 String[] map_result =  map.get(map_key).split(",");%>
		  		 							<%for(int k=0;k<map_result.length;k++){
		  		 								Hashtable ht = (Hashtable)attach_vt.elementAt(Integer.parseInt(map_result[k]));
		  		 								
		  		 								String sfile_type = ht.get("FILE_NAME")+"";
														sfile_type = sfile_type.substring(sfile_type.lastIndexOf(".")+1,sfile_type.length());
		  		 								if(k==0){%>
		  		 								<tr>
					             			<td align="center"><%=doc_count%></td>
					             		 <td>
					             		 		<%String sfile_name = ht.get("FILE_NAME")+"";
														sfile_name = sfile_name.substring(0,sfile_name.lastIndexOf("."));%>
					             		 	  &nbsp;<%=sfile_name%></td>
						           	  	
															<%if(ht.get("FILE_TYPE").equals("image/jpeg")||ht.get("FILE_TYPE").equals("image/pjpeg")||ht.get("FILE_TYPE").equals("application/pdf")){%>			
														 		<td align="center">
														 			<input type="checkbox" name="ch_l_cd" value="<%=ht.get("SEQ")%>" >
														 			<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><img src="/acar/images/center/icon_<%=sfile_type%>.gif" align=absmiddle border="0"></a>
														 <%}else{%>
														 	<td align="center">
														 		<input type="checkbox" name="ch_l_cd" value="<%=ht.get("SEQ")%>" >
														 		<a href="https://fms3.amazoncar.co.kr/fms2/attach/download.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/icon_<%=sfile_type%>.gif" align=absmiddle border="0"></a>
														 <%}%>
		  		 								
		  		 								<%}else{%>
		  		 										<input type="checkbox" name="ch_l_cd" value="<%=ht.get("SEQ")%>" >
															<%if(ht.get("FILE_TYPE").equals("image/jpeg")||ht.get("FILE_TYPE").equals("image/pjpeg")||ht.get("FILE_TYPE").equals("application/pdf")){%>			
														 		<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><img src="/acar/images/center/icon_<%=sfile_type%>.gif" align=absmiddle border="0"></a>
														 <%}else{%>
														 	<a href="https://fms3.amazoncar.co.kr/fms2/attach/download.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/icon_<%=sfile_type%>.gif" align=absmiddle border="0"></a>
														 <%}%>
		  		 								
		  		 								<%}
		  		 								if((k+1)==map_result.length){%>
		  		 							
													
														 		
														
		  		 								<%}%>
		  		 								
		  		 								
														
					             <%}%>
					            	 
					              <%
					             for(int k=0;k<map_result.length;k++){
		  		 								Hashtable ht = (Hashtable)attach_vt.elementAt(Integer.parseInt(map_result[k]));
		  		 								if(1!=1){
		  		 											if(k==0){%>
		  		 													</td>
		  		 													<td align="center">
		  		 										  		<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
		  		 											<%}else{%>
		  		 											
		  		 													<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
		  		 											<%}
		  		 											if((k+1)==map_result.length){%>
										  		 								 	</td>
																				</tr>
																		</tr>
		  		 											<%}
		  		 						}%>
		  		 						
       		 				<%}	
       		 				
		  		}
  
       %>
		</table>
	  </td>
	</tr>
  </table>
</form>
</body>
</html>  