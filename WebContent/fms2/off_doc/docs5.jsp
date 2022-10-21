<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,acar.common.*,acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>
<%
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String content_code = "OFF_DOC";
	String content_seq  = "docs5";
	
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
	//스캔등록
	function scan_reg(docs_menu){
		window.open("reg_scan.jsp?docs_menu="+docs_menu, "SCAN", "left=10, top=10, width=720, height=400, scrollbars=yes, status=yes, resizable=yes");
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
		fm.action = "/fms2/off_doc/select_mail_input_docs.jsp";
		fm.submit();	

	}		
	
//-->
</script>
</head>

<body leftmargin="15">
	<form name="form1" method="POST">
	<input type="hidden" name="user_id" value="<%=user_id%>">
	<input type="hidden" name="send_seq" value="">
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>자료실 > <span class=style5>영업팀업무서식</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
                <tr>
                	<td colspan="3 "align='right' >

                		<a href="javascript:select_email();"><img src=/acar/images/center/button_send_smail.gif align=absmiddle border=0></a>
                		<%//if(nm_db.getWorkAuthUser("임원",user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || user_id.equals("000077")|| user_id.equals("000144")){%>			
                		<a href="javascript:scan_reg('<%=content_seq%>')"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
                		<%//}%>
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
			<td class='title' width='50'>연번</td>
			<td class='title' width='700'>구분</td>
			<td class='title' width='100'>종류</td>		
			<%if(nm_db.getWorkAuthUser("임원",user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("자료실관리",user_id) || nm_db.getWorkAuthUser("영업팀내근직",user_id)){%>			
			<td class='title' width='150'>삭제</td>				
			<%}%>				
		  </tr>
		    <%
		  	Map<String, String> map = new HashMap<String, String>();
       
       	for(int k=0;k<attach_vt_size;k++){
        	 Hashtable ht = (Hashtable)attach_vt.elementAt(k);
        	 String ht_string =ht.get("FILE_NAME")+"";
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
														 			<a href="javascript:openPopF('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><img src="/acar/images/center/icon_<%=sfile_type%>.gif" align=absmiddle border="0"></a>
														 <%}else{%>
														 	<td align="center">
														 		<input type="checkbox" name="ch_l_cd" value="<%=ht.get("SEQ")%>" >
														 		<a href="https://fms3.amazoncar.co.kr/fms2/attach/download.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/icon_<%=sfile_type%>.gif" align=absmiddle border="0"></a>
														 <%}%>
		  		 								
		  		 								<%}else{%>
		  		 										<input type="checkbox" name="ch_l_cd" value="<%=ht.get("SEQ")%>" >
															<%if(ht.get("FILE_TYPE").equals("image/jpeg")||ht.get("FILE_TYPE").equals("image/pjpeg")||ht.get("FILE_TYPE").equals("application/pdf")){%>			
														 		<a href="javascript:openPopF('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><img src="/acar/images/center/icon_<%=sfile_type%>.gif" align=absmiddle border="0"></a>
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
		  		 								if(nm_db.getWorkAuthUser("임원",user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("자료실관리",user_id) || nm_db.getWorkAuthUser("영업팀내근직",user_id)){
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
	  <!--
		  <tr>
			<td align="center">1</td>
			<td>&nbsp;(심사용) 개인신용정보 조회동의서(2016.03.16~)</td>
			<td align="center"><a href="javascript:MM_openBrWindow('(심사용)개인(신용)정보 수집_이용_조회동의서(2016-03-16~).hwp','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')"><img src=/acar/images/center/icon_hwp.gif align=absmiddle border="0"></a>&nbsp;
			<a href="javascript:MM_openBrWindow('(심사용)개인(신용)정보 수집_이용_조회동의서(2016-03-16~).pdf','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')"><img src=/acar/images/center/icon_pdf.gif align=absmiddle border="0"></a></td>
		  </tr>
		  
		  <tr>
			<td align="center">2</td>
			<td>&nbsp;제3자보증 연대보증서양식</td>
			<td align="center"><a href="javascript:MM_openBrWindow('제3자보증연대보증서양식.xls','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')"><img src=/acar/images/center/icon_excel.gif align=absmiddle border="0"></a></td>
		  </tr>
			<tr>
			<td align="center">3</td>
			<td>&nbsp;자동차 보험 관련 특약 약정서(보험계약자 고객)</td>
			<td align="center"><a href="javascript:MM_openBrWindow('자동차 보험 관련 특약 약정서(보험계약자 고객).pdf','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')"><img src=/acar/images/center/icon_pdf.gif align=absmiddle border="0"></a></td>
		  </tr>
		  <tr>
			<td align="center">4</td>
			<td>&nbsp;리스보험 가입 관련 업무 표준 및 업무처리 방법</td>
			<td align="center"><a href="javascript:MM_openBrWindow('리스보험 가입 관련 업무 표준 및 업무처리 방법.pdf','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')"><img src=/acar/images/center/icon_pdf.gif align=absmiddle border="0"></a></td>
		  </tr>
		  -->
		</table>
	  </td>
	</tr>
	
    <%//if(nm_db.getWorkAuthUser("전산팀",user_id)){%>
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
			<td class='title' width='50'>연번</td>
			<td class='title'>구분</td>	
			<td class='title' width='150'>전자문서</td>					
		  </tr>	
		  <tr>
			<td align="center">1</td>
			<td>&nbsp;(심사용)개인(신용)정보 수집_이용_조회동의서</td>
			<td align="center"><button class="button" name="mail1" id="mail2" onclick="javascript:confirmDoc('mail','11');">발송</button></td>
		  </tr>		  
		</table>
	  </td>
	</tr>	
	<%//}%>	
  </table>
  </form>
  <form name="printForm" method="post">
	<input type="hidden" name="user_id" value="<%=ck_acar_id%>">						
	<input type="hidden" name="type" value="">
	<input type="hidden" name="var1" value="<%=ck_acar_id%>">
	<input type="hidden" name="mail_yn" value="">
	<input type="hidden" name="doc_url" value="">
	<input type="hidden" name="client_st" value="0">
</form>
<script>
	
	function confirmDoc(st, type){
		
		var frmData = document.printForm;

		var url = "about:blank";
		var width = 500;
		var height = 500;
		
		window.open(url, 'CONFIRM_TEMPLATE', "left=50, top=50, width="+width+", height="+height+", scrollbars=yes");
		
		frmData.type.value = type;
				
		//type = 11 ;(심사용)개인(신용)정보 수집_이용_조회동의서
		
		var doc_url = "/edoc_fms/acar/e_doc/confirm_template_link"+type+".jsp";
		
		frmData.doc_url.value = doc_url;
		
		frmData.action = "/fms2/lc_rent/select_mail_input_e_doc.jsp";
		
		frmData.target = "CONFIRM_TEMPLATE";
		
		frmData.submit();

	}	

</script>  
</body>
</html>