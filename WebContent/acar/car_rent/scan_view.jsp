<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//스캔관리 페이지
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String brch_id 	= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String file_st = "";
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		theURL = "https://fms3.amazoncar.co.kr/data/"+theURL+".pdf";
		window.open(theURL,winName,features);
	}
	//등록하기
	function save(){
		fm = document.form1;
		if(fm.file_st.value == ""){		alert("구분을 선택해 주세요!");		fm.file_st.focus();		return;		}
		else if(fm.file_name == ""){	alert("파일을 선택해 주세요!");		fm.file_name.focus();	return;		}
		
		if(!confirm("해당 파일을 등록하시겠습니까?"))	return;
//		fm.target = "i_no";
		fm.submit();
	}
	//삭제하기
	function remove(seq, st_nm){
		fm = document.form1;
		fm.remove_seq.value = seq;
		if(!confirm(st_nm+".pdf 파일을 삭제하시겠습니까?"))		return;
		fm.target = "i_no";
		fm.submit();
	}	
	
		//팝업윈도우 열기
	function ScanOpen(theURL,file_path,file_type) { //v2.0
		theURL = "https://fms3.amazoncar.co.kr/data/"+file_path+""+theURL+""+file_type;
		if(file_type == '.jpg'){
			window.open('/fms2/lc_rent/img_scan_view.jsp?img_url='+theURL,'popwin_in1','scrollbars=yes,status=yes,resizable=yes,width=<%=(2100*0.378)+50%>,height=<%=s_height%>,left=0, top=0');
		}else{
			window.open(theURL,'popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50');
		}
	}
//-->
</script>
</head>

<body>
<center>
<form name='form1' action='scan_view_a.jsp' method='post' enctype="multipart/form-data">
<input type='hidden' name="m_id" value="<%=m_id%>">
<input type='hidden' name="l_cd" value="<%=l_cd%>">
<input type='hidden' name="seq" value="">
<input type='hidden' name="remove_seq" value="">
<table border="0" cellspacing="0" cellpadding="0" width=570>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>스캔관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
	      <%	Hashtable est = a_db.getRentEst(m_id, l_cd);%>
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
                    <td class='title' width=15%>계약번호</td>
                    <td width=25%>&nbsp;<%=l_cd%></td>
                    <td class='title' width=15%>상호</td>
                    <td width=45%>&nbsp;<%=est.get("FIRM_NM")%></td>
                </tr>
                <tr> 
                    <td class='title'>차량번호</td>
                    <td>&nbsp;<%=est.get("CAR_NO")%></td>
                    <td class='title'>차명</td>
                    <td>&nbsp;<%=est.get("CAR_NM")%> <%=est.get("CAR_NAME")%></td>
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
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class="title" width='5%'>연번</td>
                    <td class="title" width='15%'>구분</td>
                    <td class="title" width='35%'>설명</td>
                    <td class="title" width='20%'>파일보기</td>
                    <td class="title" width='15%'>등록일</td>
                    <td class="title" width='10%'>삭제</td>
                </tr>
            
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right">&nbsp;</td>
    </tr>
	  <%//if(br_id.equals("S1") || br_id.equals(brch_id)){%>
	<tr> 
        <td class=line2></td>
    </tr>
    <tr>
        <td align="right" class="line">
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title' width=15%>구분</td>
                    <td width=85%>
        			&nbsp;<select name="file_st">
                        <option value="1" <%if(file_st.equals("1")){%>selected<%}%>>계약서</option>
                        <option value="2" <%if(file_st.equals("2")){%>selected<%}%>>사업자등록증</option>
                        <option value="3" <%if(file_st.equals("3")){%>selected<%}%>>법인등기부등본</option>				
                        <option value="6" <%if(file_st.equals("6")){%>selected<%}%>>법인인감증명서</option>								
                        <option value="4" <%if(file_st.equals("4")){%>selected<%}%>>신분증</option>				
                        <option value="7" <%if(file_st.equals("7")){%>selected<%}%>>주민등록등본</option>				
                        <option value="8" <%if(file_st.equals("8")){%>selected<%}%>>인감증명서</option>								
                        <option value="9" <%if(file_st.equals("9")){%>selected<%}%>>통장사본</option>
                        <option value="10" <%if(file_st.equals("10")){%>selected<%}%>>세금계산서</option>				
                        <option value="5" <%if(file_st.equals("5")){%>selected<%}%>>기타</option>				
                      </select>
                    </td>
                </tr>
                <tr>
                    <td class='title'>설명</td>
                    <td>&nbsp;<input type="text" name="file_cont" size="60" class="text">
                    </td>
                </tr>
                <tr>
                    <td class='title'>스캔파일</td>
                    <td>&nbsp;<input type="file" name="filename2" size="40">
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td align="right"><a href='javascript:save()' onMouseOver="window.status=''; return true"><img src=../images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;&nbsp;<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=../images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
	  <%// 	}else{ %>
      <!--<tr>
        <td align="right"><a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src="/images/close.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
      </tr>-->
	  <%// 	}%>	  
</table>
</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</body>
</html>
