<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,acar.common.*,acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>
<%
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
		MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String content_code = "OFF_DOC";
	String content_seq  = "docs8";
	
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
	
	//대차료 동의서 안내문 및 위임장 링크
	function go_print_doc_ect(){
		window.open("/acar/res_stat/myaccid_doc_email.jsp", "PRINT", "left=10, top=10, width=900, height=900, scrollbars=yes, status=yes, resizable=yes");
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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>자료실 > <span class=style5>기타서식</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
                <tr>
                	<td colspan="3 "align='right' >
                		<a href="javascript:select_email();"><img src=/acar/images/center/button_send_smail.gif align=absmiddle border=0></a>
                			<%//if(nm_db.getWorkAuthUser("임원",user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("총무팀남",user_id)){%>
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
			<td class='title' width='40'>연번</td>
			<td class='title' width='700'>구분</td>
			<td class='title' width='100'>종류</td>		
			<%if(nm_db.getWorkAuthUser("임원",user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("총무팀남",user_id)){%>			
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
		  		 								if(nm_db.getWorkAuthUser("임원",user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("총무팀남",user_id) ){
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
		  		  
		  		// 대차료 동의서 안내문 및 위임장 링크 추가(프린트용)(2017.12.20) 
		  		if(nm_db.getWorkAuthUser("임원",user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("총무팀남",user_id)){%>
	               <tr>
          			<td align="center"><%=doc_count+1%></td>
          			<td>&nbsp;대차료동의서 안내문및 위임장&nbsp;(프린트용, 메일발송불가)</td>
          			<td align="center"><a href="javascript:go_print_doc_ect();">웹 문서</a></td>
          			<td></td>
          		</tr>	
      <%		}  %>
		  <!--
		  <tr>
			<td align="center">1</td>
			<td>&nbsp;<a href="javascript:MM_openBrWindow('gochung.xls','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')">고충처리 요청서</a></td>
			<td align="center"><a href="javascript:MM_openBrWindow('gochung.xls','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')"><img src=/acar/images/center/icon_excel.gif align=absmiddle border="0"></a></td>
		  </tr>
		  <tr>
			<td align="center">2</td>
			<td>&nbsp;<a href="javascript:MM_openBrWindow('단기대여 요금표.jpg','popwin_in1','scrollbars=yes,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=700,left=50, top=50')">단기대여 요금표(2009.01.15)</a>
				&nbsp;<a href="javascript:MM_openBrWindow('아마존카_단기대여_요금표_20111001.jpg','popwin_in1','scrollbars=yes,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=700,left=50, top=50')">단기대여 요금표(2011.10.01)</a>
				&nbsp;<a href="javascript:MM_openBrWindow('아마존카_단기대여_요금표_20140101.jpg','popwin_in1','scrollbars=yes,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=700,left=50, top=50')">단기대여 요금표(2014.01.01)</a>
				&nbsp;<a href="javascript:MM_openBrWindow('아마존카_단기대여_요금표.jpg','popwin_in1','scrollbars=yes,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=700,left=50, top=50')">단기대여 요금표(2015.01.01)</a>
			</td>
			<td align="center"><img src=/acar/images/center/icon_jpg.gif align=absmiddle border="0"></td>
		  </tr>
		  <tr>
			<td align="center">3</td>
			<td>&nbsp;대차료 청구소송 판결문 <a href="javascript:MM_openBrWindow('page-1.jpg','popwin_in1','scrollbars=yes,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=700,left=50, top=50')">1페이지</a>&nbsp;
			<a href="javascript:MM_openBrWindow('page-2.jpg','popwin_in1','scrollbars=yes,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=700,left=50, top=50')">2페이지</a>&nbsp;
			<a href="javascript:MM_openBrWindow('page-3.jpg','popwin_in1','scrollbars=yes,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=700,left=50, top=50')">3페이지</a>&nbsp;
			</td>
			<td align="center"><a href="javascript:MM_openBrWindow('page_all.zip','popwin_in1','scrollbars=yes,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=700,left=50, top=50')"><img src=/acar/images/center/icon_zip.gif align=absmiddle border="0"></a></td>
		  </tr>
		  <tr>
			<td align="center">4</td>
			<td>&nbsp;<a href="javascript:MM_openBrWindow('page-4.jpg','popwin_in1','scrollbars=yes,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=700,left=50, top=50')">단기대여 5사 요금 평균표</a></td>
			<td align="center"><a href="javascript:MM_openBrWindow('page-4.jpg','popwin_in1','scrollbars=yes,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=700,left=50, top=50')"><img src=/acar/images/center/icon_jpg.gif align=absmiddle border="0"></a></td>
		  </tr>
		  <tr>
			<td align="center">5</td>
			<td>&nbsp;대차료 청구소송 항소심 판결문 <a href="javascript:MM_openBrWindow('2011나10012보험금판결서.pdf','popwin_in1','scrollbars=yes,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=700,left=50, top=50')">판결문</a>&nbsp;
			</td>
			<td align="center"><a href="javascript:MM_openBrWindow('2011나10012보험금판결서.pdf','popwin_in1','scrollbars=yes,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=700,left=50, top=50')"><img src=/acar/images/center/icon_pdf.gif align=absmiddle border="0"></a></td>
		  </tr>
		  <tr>
			<td align="center">6</td>
			<td>&nbsp;자동차대여 표준약관(표준약관 제10064호, 2011. 9. 23. 개정)_축소2장인쇄용 <a href="javascript:MM_openBrWindow('월렌트표준약관.pdf','popwin_in1','scrollbars=yes,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=700,left=50, top=50')">월렌트표준약관</a>&nbsp;
			</td>
			<td align="center"><a href="javascript:MM_openBrWindow('월렌트표준약관.pdf','popwin_in1','scrollbars=yes,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=700,left=50, top=50')"><img src=/acar/images/center/icon_pdf.gif align=absmiddle border="0"></a></td>
		  </tr>
		  <tr>
			<td align="center">7</td>
			<td>&nbsp;공문양식 <a href="javascript:MM_openBrWindow('공문양식.xls','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')">엑셀</a>&nbsp;
			<a href="javascript:MM_openBrWindow('공문양식.hwp','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')">한글</a>&nbsp;
			<a href="javascript:MM_openBrWindow('공문양식.doc','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')">워드</a></td>
			<td align="center"><a href="javascript:MM_openBrWindow('공문양식.xls','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')"><img src=/acar/images/center/icon_excel.gif align=absmiddle border="0"></a>&nbsp;
			<a href="javascript:MM_openBrWindow('공문양식.hwp','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')"><img src=/acar/images/center/icon_hwp.gif align=absmiddle border="0"></a>&nbsp;
			<a href="javascript:MM_openBrWindow('공문양식.doc','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')"><img src=/acar/images/center/icon_doc.gif align=absmiddle border="0"></a></td>
		  </tr>
		  <tr>
			<td align="center">8</td>
			<td>&nbsp;고객피보험 산출에 필요한 자료 <a href="javascript:MM_openBrWindow('고객피보험산출시필요한자료.hwp','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')">한글</a>&nbsp;
			<td align="center"><a href="javascript:MM_openBrWindow('고객피보험산출시필요한자료.hwp','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')"><img src=/acar/images/center/icon_hwp.gif align=absmiddle border="0"></a>&nbsp;
		  </tr>-->
		</table>
	  </td>
	</tr>
  </table>
  </form>
</body>
</html>