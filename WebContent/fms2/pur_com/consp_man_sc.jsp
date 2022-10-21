<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,  acar.util.*, acar.user_mng.*, acar.consignment.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 
<%@ include file="/acar/access_log.jsp" %>

<%
	String car_comp_id = "";
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();

	if(nm_db.getWorkAuthUser("외부_자동차사",ck_acar_id)){
		UsersBean user_bean 	= umd.getUsersBean(ck_acar_id);
		if(user_bean.getUser_nm().equals("현대자동차")){
			car_comp_id	= "0001";
		}else if(user_bean.getUser_nm().equals("기아숭실") || user_bean.getUser_nm().equals("기아학익") || user_bean.getUser_nm().equals("기아세종") || user_bean.getUser_nm().equals("기아증산")){
			car_comp_id	= "0002";
		}else if(user_bean.getUser_nm().equals("지엠강서구청")){	//지엠강서구청점 추가 (2018.03.22)
			car_comp_id	= "0004";
		}
	}		
	
	Vector vt = cs_db.getConsignmentPurManList(car_comp_id);
	int vt_size = vt.size();	
%>
<html>
<head>
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<script language='javascript'>
<!--
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body leftmargin="15">
<form name='form1' method='post'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>계출관리 > <span class=style5>출고대리인현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
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
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td width='3%' rowspan="3" class='title'>연번</td>
		    <td width='15%' rowspan="3" class='title'>제조사</td>
		    <td width='10%' rowspan="3" class='title'>출고사무소</td>
		    <td colspan="5" class='title'>탁송업체</td>				  				  
		    <td width='10%' rowspan="3" class='title'>등록일자</td>
		</tr>
		<tr>
		    <td width='13%' rowspan="2" class='title'>상호</td>
		    <td width='13%' rowspan="2" class='title'>전화번호</td>		    
		    <td colspan="3" class='title'>출고대리인</td>				  				  
		</tr>
		<tr>
		    <td width='10%' class='title'>성명</td>
		    <td width='16%' class='title'>생년월일</td>
		    <td width='10%' class='title'>전화번호</td>		    
		</tr>
<%		if(vt_size > 0){ %>	
<%			for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
%>
		<tr>
		    <td align='center'><%=i+1%></td>
		    <td align='center'><%=ht.get("CAR_COMP_NM")%></td>
		    <td align='center'><%=ht.get("DLV_EXT")%></td>
		    <td align='center'><%=ht.get("OFF_NM")%></td>
		    <td align='center'><%=ht.get("OFF_TEL")%></td>
		    <td align='center'><%=ht.get("MAN_NM")%></td>
		    <td align='center'><%=ht.get("MAN_SSN")%></td>
		    <td align='center'><%=ht.get("MAN_TEL")%></td>
		    <td align='center'><%=ht.get("REG_DT")%></td>
		</tr>
<%			}
		}else{
%>	
		<tr>
			<td colspan="9" align="center">등록된 데이터가 없습니다.</td>
		</tr>
<%		} %>
	    </table>
	</td>
    </tr>
</table>
</form>
</body>
</html>

