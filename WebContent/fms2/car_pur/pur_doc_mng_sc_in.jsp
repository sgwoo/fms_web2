<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.user_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	String cmd = "";
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();

	t_wd = "법인판";
	
	Vector fines = FineDocDb.getFineDocLists("특판", br_id, gubun1, gubun2, gubun3,  gubun4, "L", st_dt, end_dt, s_kd, t_wd, sort, asc);
	int fine_size = fines.size();
%>

<html>
<head><title>FMS</title>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

	
	//전체선택
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_cd"){		
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}
		}
		return;
	}	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">

<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='fee_size' value='<%=fine_size%>'>

<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr>
	    <td class='line'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
				<%if(user_id.equals("000096")){%>
					<td class='title' width=5%><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
					<%}%>
                    <td class='title' width=5%>연번</td>
                    <td width=15% class='title'>문서번호</td>
                    <td width=20% class='title'>수신처</td>
                    <td width=10% class='title'>발신일자</td>
					<td class='title' width=10%>담당자</td>
					<td class='title' width=15%>차량메이커</td>
					<td class='title' width=10%>카드사</td>
					<td class='title' width=10%>금액</td>						
				</tr>
            </table>
	    </td>
    </tr> 
    <tr>
	    <td class='line'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <%for(int i = 0 ; i < fine_size ; i++){
    				Hashtable ht = (Hashtable)fines.elementAt(i);%>
              <tr>
			  <%if(user_id.equals("000096")){%>
				<td align='center' width=5%><input type="checkbox" name="ch_cd" value="<%=ht.get("RENT_L_CD")%><%=ht.get("RENT_MNG_ID")%><%=ht.get("NUM")%>"></td>
				<%}%>
                <td align='center' width=5%><%=i+1%></td>
                <td  width=15% align='center'><a href="javascript:parent.Pur_DocPrint('<%=ht.get("SDOC_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("DOC_ID")%></a></td>
                <td  width=20% align='center'><%=ht.get("MNG_NM")%>&nbsp;<%=ht.get("MNG_POS")%></td>
                <td  width=10% align='center'><%=AddUtil.getDate3(String.valueOf(ht.get("DOC_DT")))%></td>
				<td align="center" width=10%><%=ht.get("MNG_DEPT")%></td>
                <td  width=15% align='center'><%=ht.get("MNG_NM")%></td>
				<td align="center" width=10%><%=ht.get("FIRM_NM")%></td>
                <td  width=10% align='right'><%=AddUtil.parseDecimal(ht.get("AMT1"))%>원&nbsp;</td>			
              </tr>
              <%}%>		  
    		  <%if(fine_size==0){%>
                <td  align='center'></td>		  
              <%}%>				  
            </table>
	    </td>
    </tr>
</table>
</form>
</body>
</html>
