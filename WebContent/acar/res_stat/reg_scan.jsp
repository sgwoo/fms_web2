<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.res_search.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	//��ĵ���� ������
	
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String file_st	 	= request.getParameter("file_st")==null?"":request.getParameter("file_st");
	String file_cont 	= request.getParameter("file_cont")==null?"":request.getParameter("file_cont");
	String remove_seq	= request.getParameter("remove_seq")==null?"":request.getParameter("remove_seq");
	String idx		= request.getParameter("idx")==null?"":request.getParameter("idx");
	String rent_st		= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String rent_mng_id2 	= request.getParameter("rent_mng_id2")==null?"":request.getParameter("rent_mng_id2");
	String rent_l_cd2 	= request.getParameter("rent_l_cd2")==null?"":request.getParameter("rent_l_cd2");
	
	//��������
	Hashtable reserv = rs_db.getCarInfo(rent_mng_id);
	
	//�ܱ�������
	RentContBean rc_bean = rs_db.getRentContCase(rent_l_cd, rent_mng_id);
	
	//������
	RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id());
	
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//����ϱ�
	function save(){
		fm = document.form1;
		
		if(fm.file_st.value == ""){	alert("������ ������ �ּ���!");		fm.file_st.focus();	return;		}		
		if(fm.file.value == ""){	alert("������ ������ �ּ���!");		fm.file.focus();	return;		}		
		
		if(!confirm("�ش� ������ ����Ͻðڽ��ϱ�?"))	return;
		
		fm.<%=Webconst.Common.contentSeqName%>.value = fm.<%=Webconst.Common.contentSeqName%>.value+''+fm.file_st.value;
						
		fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/fileuploadact.jsp?<%=Webconst.Common.contentCodeName%>=<%=UploadInfoEnum.SC_SCAN%>";				
		fm.submit();
	}
	
//-->
</script>
</head>

<body>
<center>
<form name='form1' action='' method='post' enctype="multipart/form-data">
  <input type='hidden' name="auth_rw" 		value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 		value="<%=user_id%>">
  <input type='hidden' name="br_id"   		value="<%=br_id%>">
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="remove_seq"	value="<%=remove_seq%>">
  <input type='hidden' name="idx"		value="<%=idx%>">
  <input type='hidden' name="rent_st"		value="<%=rent_st%>">
  <input type='hidden' name="from_page" 	value="<%=from_page%>">  
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>����ý��� ��ĵ���</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
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
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'>����ȣ</td>
                    <td width='15%'>&nbsp;<%=rent_l_cd%></td>
                    <td class='title' width='15%'>��ȣ</td>
                    <td>&nbsp;<%=rc_bean2.getCust_nm()%></td>
                </tr>
                <tr> 
                    <td class='title'>������ȣ</td>
                    <td>&nbsp;<%=reserv.get("CAR_NO")%></td>
                    <td class='title'>����</td>
                    <td>&nbsp;<%=reserv.get("CAR_NM")%>&nbsp;<%=reserv.get("CAR_NAME")%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>
    <tr>
	<td class=line2></td>
    </tr>
    <tr>
        <td align="right" class="line">
	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title' width='15%'>����</td>
                    <td>
        	      &nbsp;<select name="file_st">
                        <option value="1" <%if(file_st.equals("1")){%>selected<%}%>>���ʰ�༭</option>
                        <option value="17" <%if(file_st.equals("17")){%>selected<%}%>>�뿩�����İ�༭(��)jpg</option>						
                        <option value="18" <%if(file_st.equals("18")){%>selected<%}%>>�뿩�����İ�༭(��)jpg</option>												
                        <option value="2" <%if(file_st.equals("2")){%>selected<%}%>>����ڵ����jpg</option>
                        <option value="3" <%if(file_st.equals("3")){%>selected<%}%>>���ε��ε</option>				
                        <option value="6" <%if(file_st.equals("6")){%>selected<%}%>>�����ΰ�����</option>                        
                        <option value="4" <%if(file_st.equals("4")){%>selected<%}%>>�ź���jpg</option>				
                        <option value="7" <%if(file_st.equals("7")){%>selected<%}%>>�ֹε�ϵ</option>				
                        <option value="8" <%if(file_st.equals("8")){%>selected<%}%>>�ΰ�����</option>												
                        <option value="14" <%if(file_st.equals("14")){%>selected<%}%>>���뺸����</option>				
                        <option value="11" <%if(file_st.equals("11")){%>selected<%}%>>�����νź���</option>				
                        <option value="12" <%if(file_st.equals("12")){%>selected<%}%>>�����ε</option>				
                        <option value="13" <%if(file_st.equals("13")){%>selected<%}%>>�������ΰ�����</option>												
                        <option value="9" <%if(file_st.equals("9")){%>selected<%}%>>����纻</option>
                        <option value="5" <%if(file_st.equals("5") || file_st.equals("")){%>selected<%}%>>��Ÿ</option>				
                        <option value="24" <%if(file_st.equals("24")){%>selected<%}%>>�ֿ����ڿ���������</option>
                        <option value="27" <%if(file_st.equals("27")){%>selected<%}%>>�߰������ڿ���������</option>
                        <option value="25" <%if(file_st.equals("25")){%>selected<%}%>>���������ε���</option>
                        <option value="26" <%if(file_st.equals("26")){%>selected<%}%>>���������μ���</option>
                        <option value="28" <%if(file_st.equals("28")){%>selected<%}%>>�⺻�������������������</option>
                      </select> 			
                    </td>
                </tr>
                <tr>
                    <td class='title'>��ĵ����</td>
                    <td>
                        <input type="file" name="file" size="50" class=text>
                        <input type="hidden" name="<%=Webconst.Common.contentSeqName%>" value='<%=rent_mng_id%><%=rent_l_cd%>'>
                        <input type='hidden' name='<%=Webconst.Common.contentCodeName%>' value='<%=UploadInfoEnum.SC_SCAN%>'>                               			    
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td align="right"><a href='javascript:save()'><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;&nbsp;<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
</center>
</body>
</html>
