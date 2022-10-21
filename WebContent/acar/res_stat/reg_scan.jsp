<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.res_search.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	//스캔관리 페이지
	
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
	
	//차량정보
	Hashtable reserv = rs_db.getCarInfo(rent_mng_id);
	
	//단기계약정보
	RentContBean rc_bean = rs_db.getRentContCase(rent_l_cd, rent_mng_id);
	
	//고객정보
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
	//등록하기
	function save(){
		fm = document.form1;
		
		if(fm.file_st.value == ""){	alert("구분을 선택해 주세요!");		fm.file_st.focus();	return;		}		
		if(fm.file.value == ""){	alert("파일을 선택해 주세요!");		fm.file.focus();	return;		}		
		
		if(!confirm("해당 파일을 등록하시겠습니까?"))	return;
		
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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>예약시스템 스캔등록</span></span></td>
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
                    <td class='title' width='15%'>계약번호</td>
                    <td width='15%'>&nbsp;<%=rent_l_cd%></td>
                    <td class='title' width='15%'>상호</td>
                    <td>&nbsp;<%=rc_bean2.getCust_nm()%></td>
                </tr>
                <tr> 
                    <td class='title'>차량번호</td>
                    <td>&nbsp;<%=reserv.get("CAR_NO")%></td>
                    <td class='title'>차명</td>
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
                    <td class='title' width='15%'>구분</td>
                    <td>
        	      &nbsp;<select name="file_st">
                        <option value="1" <%if(file_st.equals("1")){%>selected<%}%>>최초계약서</option>
                        <option value="17" <%if(file_st.equals("17")){%>selected<%}%>>대여개시후계약서(앞)jpg</option>						
                        <option value="18" <%if(file_st.equals("18")){%>selected<%}%>>대여개시후계약서(뒤)jpg</option>												
                        <option value="2" <%if(file_st.equals("2")){%>selected<%}%>>사업자등록증jpg</option>
                        <option value="3" <%if(file_st.equals("3")){%>selected<%}%>>법인등기부등본</option>				
                        <option value="6" <%if(file_st.equals("6")){%>selected<%}%>>법인인감증명서</option>                        
                        <option value="4" <%if(file_st.equals("4")){%>selected<%}%>>신분증jpg</option>				
                        <option value="7" <%if(file_st.equals("7")){%>selected<%}%>>주민등록등본</option>				
                        <option value="8" <%if(file_st.equals("8")){%>selected<%}%>>인감증명서</option>												
                        <option value="14" <%if(file_st.equals("14")){%>selected<%}%>>연대보증서</option>				
                        <option value="11" <%if(file_st.equals("11")){%>selected<%}%>>보증인신분증</option>				
                        <option value="12" <%if(file_st.equals("12")){%>selected<%}%>>보증인등본</option>				
                        <option value="13" <%if(file_st.equals("13")){%>selected<%}%>>보증인인감증명서</option>												
                        <option value="9" <%if(file_st.equals("9")){%>selected<%}%>>통장사본</option>
                        <option value="5" <%if(file_st.equals("5") || file_st.equals("")){%>selected<%}%>>기타</option>				
                        <option value="24" <%if(file_st.equals("24")){%>selected<%}%>>주운전자운전면허증</option>
                        <option value="27" <%if(file_st.equals("27")){%>selected<%}%>>추가운전자운전면허증</option>
                        <option value="25" <%if(file_st.equals("25")){%>selected<%}%>>배차차량인도증</option>
                        <option value="26" <%if(file_st.equals("26")){%>selected<%}%>>반차차량인수증</option>
                        <option value="28" <%if(file_st.equals("28")){%>selected<%}%>>기본식유상정비대차견적서</option>
                      </select> 			
                    </td>
                </tr>
                <tr>
                    <td class='title'>스캔파일</td>
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
