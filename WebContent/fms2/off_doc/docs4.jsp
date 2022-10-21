<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,acar.common.*,acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>
<%
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
		MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	String content_code = "OFF_DOC";
	String content_seq  = "docs4";
	
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
	//��ĵ���
	function scan_reg(docs_menu){
		window.open("reg_scan.jsp?docs_menu="+docs_menu, "SCAN", "left=10, top=10, width=720, height=400, scrollbars=yes, status=yes, resizable=yes");
	}
	
	
	//���ø��Ϲ߼�
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
		 	alert("���������� �����ϼ���.");
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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�ڷ�� > <span class=style5>����������»纻</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
                <tr>
                	<td colspan="3 "align='right' >
                		<a href="javascript:select_email();"><img src=/acar/images/center/button_send_smail.gif align=absmiddle border=0></a>
                		<%//if(nm_db.getWorkAuthUser("�ӿ�",user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�����ⳳ",user_id)){%>			
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
			<td class='title' width='40'>����</td>
			<td class='title' width='700'>����</td>
			<td class='title' width='100'>����</td>		
			<%if(nm_db.getWorkAuthUser("�ӿ�",user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�����ⳳ",user_id) || nm_db.getWorkAuthUser("�ڷ�ǰ���",user_id)){%>			
			<td class='title' width='150'>����</td>	
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
														 			<a href="javascript:openPopF('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><img src="/acar/images/center/icon_<%=sfile_type%>.gif" align=absmiddle border="0"></a>
														 <%}else{%>
														 	<td align="center">
														 		<input type="checkbox" name="ch_l_cd" value="<%=ht.get("SEQ")%>" >
														 		<a href="https://fms3.amazoncar.co.kr/fms2/attach/download.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/icon_<%=sfile_type%>.gif" align=absmiddle border="0"></a>
														 <%}%>
		  		 								
		  		 								<%}else{%>
		  		 										<input type="checkbox" name="ch_l_cd" value="<%=ht.get("SEQ")%>" >
		  		 							
															<%if(ht.get("FILE_TYPE").equals("image/jpeg")||ht.get("FILE_TYPE").equals("image/pjpeg")||ht.get("FILE_TYPE").equals("application/pdf")){%>			
														 		<a href="javascript:openPopF('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><img src="/acar/images/center/icon_<%=sfile_type%>.gif" align=absmiddle border="0"></a>
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
		  		 								if(nm_db.getWorkAuthUser("�ӿ�",user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("�����ⳳ",user_id) || nm_db.getWorkAuthUser("�ڷ�ǰ���",user_id)){
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
			<td>&nbsp;<a href="javascript:MM_openBrWindow('�Ƹ���ī_��������_����纻.pdf','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')">��������纻</a></td>
			<td align="center"><a href="javascript:MM_openBrWindow('�Ƹ���ī_��������_����纻.pdf','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')"><img src=/acar/images/center/icon_pdf.gif align=absmiddle border="0"></a></td>
		  </tr>
		  <tr>
			<td align="center">2</td>
			<td>&nbsp;<a href="javascript:MM_openBrWindow('����纻_����_�츮_����.pdf','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')">����纻_����_�츮_����</a></td>
			<td align="center"><a href="javascript:MM_openBrWindow('����纻_����_�츮_����.pdf','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')"><img src=/acar/images/center/icon_pdf.gif align=absmiddle border="0"></a></td>
		  </tr>
	  
		  <tr>
			<td align="center">1</td>
			<td>&nbsp;<a href="javascript:MM_openBrWindow('SC������������纻.pdf','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')">SC������������纻(364-20-154019)</a></td>
			<td align="center"><a href="javascript:MM_openBrWindow('SC������������纻.pdf','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')"><img src=/acar/images/center/icon_pdf.gif align=absmiddle border="0"></a></td>
		  </tr>
		  
		  <tr>
			<td align="center">2</td>
			<td>&nbsp;<a href="javascript:MM_openBrWindow('������������纻.pdf','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')">������������纻(385-01-0026-124)</a></td>
			<td align="center"><a href="javascript:MM_openBrWindow('������������纻.pdf','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')"><img src=/acar/images/center/icon_pdf.gif align=absmiddle border="0"></a></td>
		  </tr>
		  
		  <tr>
			<td align="center">3</td>
			<td>&nbsp;<a href="javascript:MM_openBrWindow('�����߾���������纻.pdf','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')">�����߾���������纻(367-17-014214)</a></td>
			<td align="center"><a href="javascript:MM_openBrWindow('�����߾���������纻.pdf','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')"><img src=/acar/images/center/icon_pdf.gif align=absmiddle border="0"></a></td>
		  </tr>
		  
		  <tr>
			<td align="center">4</td>
			<td>&nbsp;<a href="javascript:MM_openBrWindow('������������纻(����).pdf','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')">������������纻-����(140-004-023856)</a></td>
			<td align="center"><a href="javascript:MM_openBrWindow('������������纻(����).pdf','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')"><img src=/acar/images/center/icon_pdf.gif align=absmiddle border="0"></a></td>
		  </tr>
		  
		  <tr>
			<td align="center">5</td>
			<td>&nbsp;<a href="javascript:MM_openBrWindow('bank_pusan.jpg','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')">������������纻-�λ�(140-003-993274)</a></td>
			<td align="center"><a href="javascript:MM_openBrWindow('bank_pusan.jpg','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')"><img src=/acar/images/center/icon_jpg.gif align=absmiddle border="0"></a></td>
		  </tr>
		  
		  <tr>
			<td align="center">6</td>
			<td>&nbsp;������������纻(140-004-023863)&nbsp;&nbsp;<a href="javascript:MM_openBrWindow('������������纻1.pdf','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')">PDF</a>&nbsp;
			<a href="javascript:MM_openBrWindow('����纻.jpg','popwin_in1','scrollbars=yes,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=700,left=50, top=50')">JPG</a></td>
			<td align="center"><a href="javascript:MM_openBrWindow('������������纻1.pdf','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')"><img src=/acar/images/center/icon_pdf.gif align=absmiddle border="0"></a>&nbsp;
			<a href="javascript:MM_openBrWindow('����纻.jpg','popwin_in1','scrollbars=yes,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=700,left=50, top=50')"><img src=/acar/images/center/icon_jpg.gif align=absmiddle border="0"></a></td>
		  </tr>
		  
		  <tr>
			<td align="center">7</td>
			<td>&nbsp;������������纻(140-004-023871)&nbsp;&nbsp;<a href="javascript:MM_openBrWindow('������������纻2.pdf','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')">PDF</a>&nbsp;
			<a href="javascript:MM_openBrWindow('����纻_3871.jpg','popwin_in1','scrollbars=yes,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=700,left=50, top=50')">JPG</a></td>
			<td align="center"><a href="javascript:MM_openBrWindow('������������纻2.pdf','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')"><img src=/acar/images/center/icon_pdf.gif align=absmiddle border="0"></a>&nbsp;
			<a href="javascript:MM_openBrWindow('����纻_3871.jpg','popwin_in1','scrollbars=yes,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=700,left=50, top=50')"><img src=/acar/images/center/icon_jpg.gif align=absmiddle border="0"></a></td>
		  </tr>
		  
		  <tr>
			<td align="center">8</td>
			<td>&nbsp;<a href="javascript:MM_openBrWindow('��Ƽ��������纻.pdf','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')">��Ƽ��������纻(163-01374-242)</a></td>
			<td align="center"><a href="javascript:MM_openBrWindow('��Ƽ��������纻.pdf','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')"><img src=/acar/images/center/icon_pdf.gif align=absmiddle border="0"></a></td>
		  </tr>
		  
		  <tr>
			<td align="center">9</td>
			<td>&nbsp;<a href="javascript:MM_openBrWindow('��ȯ��������纻.pdf','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')">��ȯ��������纻(028-22-08080-7)</a></td>
			<td align="center"><a href="javascript:MM_openBrWindow('��ȯ��������纻.pdf','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')"><img src=/acar/images/center/icon_pdf.gif align=absmiddle border="0"></a></td>
		  </tr>
		  
		  <tr>
			<td align="center">10</td>
			<td>&nbsp;<a href="javascript:MM_openBrWindow('�츮��������纻.pdf','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')">�츮��������纻(103-293206-13-001)</a></td>
			<td align="center"><a href="javascript:MM_openBrWindow('�츮��������纻.pdf','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')"><img src=/acar/images/center/icon_pdf.gif align=absmiddle border="0"></a></td>
		  </tr>
		  
		  <tr>
			<td align="center">11</td>
			<td>&nbsp;<a href="javascript:MM_openBrWindow('�ϳ���������纻.pdf','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')">�ϳ���������纻(140-910014-53104)</a></td>
			<td align="center"><a href="javascript:MM_openBrWindow('�ϳ���������纻.pdf','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')"><img src=/acar/images/center/icon_pdf.gif align=absmiddle border="0"></a></td>
		  </tr>
		  
		  
		  
		  <tr>
			<td align="center">12</td>
			<td>&nbsp;<a href="javascript:MM_openBrWindow('�߼ұ����������纻.pdf','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')">�߼ұ����������纻(221-181337-01-012)</a></td>
			<td align="center"><a href="javascript:MM_openBrWindow('�߼ұ����������纻.pdf','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')"><img src=/acar/images/center/icon_pdf.gif align=absmiddle border="0"></a></td>
		  </tr>		
		  -->	  
		</table>
	  </td>
	</tr>
  </table>
  </form>
</body>
</html>