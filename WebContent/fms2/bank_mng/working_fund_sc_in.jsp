<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.bank_mng.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String bank_id 	= request.getParameter("bank_id")==null?"":request.getParameter("bank_id");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector vt = abl_db.getWorkingFundList(gubun1, gubun2, bank_id, st_dt, end_dt);
	int vt_size = vt.size();
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--

//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
	<tr>
		<td class='line' width='100%'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width=5% rowspan="2" class=title>연번</td>
                    <td width=7% rowspan="2" class=title>ID</td>	
                    <td width=7% rowspan="2" class=title>관리번호</td>
                    <td width=7% rowspan="2" class=title>대출구분</td>
                    <td width=20% rowspan="2" class=title>금융기관</td>
                    <td width=15% rowspan="2" class=title>대출한도</td>
                    <td width=18% rowspan="2" class=title>기준금리</td>
                    <td colspan="2" class=title>변경등록</td>
                    <td width=7% rowspan="2" class=title>담당자</td>
                </tr>
                <tr>
                  <td width=7% class=title>적용금리</td>
                  <td width=7% class=title>기준일자</td>
                </tr>
	<%if(vt_size > 0){%>
        	<%for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr> 
                    <td align="center"><%= i+1%></td>
                    <td align='center'><a href="javascript:parent.view_bank_lend('<%=ht.get("FUND_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("FUND_ID")%></a></td>
                    <td align='center'><%=ht.get("FUND_NO")%></td>
                    <td align='center'><%=ht.get("FUND_TYPE")%></td>
                    <td align='center'><%=ht.get("BANK_NM")%></td>
                    <td align='right'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CONT_AMT")))%>원</td>
                    <td align='center'><%=c_db.getNameByIdCode("0023", "", String.valueOf(ht.get("APP_B_ST")))%></td>
                    <td align='right'><%=ht.get("FUND_INT")%>%</td>
                    <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("APP_B_DT")))%></td>				  
                    <td align='center'><%=ht.get("BA_AGNT")%></td>				  				  
                </tr>
            <%}%>
<%	}else{%>                     
				<tr>
					<td colspan='9' align='center'>등록된 데이타가 없습니다</td>
				</tr>
<%  }%>				
            </table>
		</td>

	</tr>
</table>
</body>
</html>
