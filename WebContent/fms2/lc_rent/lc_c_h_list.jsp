<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*"%>
<%@ page import="acar.cont.*, acar.insur.*, acar.offls_sui.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="olsD" class="acar.offls_sui.Offls_suiDatabase" scope="page"/>
<jsp:useBean id="sBean" class="acar.offls_sui.SuiBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	
	InsDatabase ai_db = InsDatabase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
//-->
</style>
</head>
<body>
<form action='lc_b_u_a.jsp' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>    
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="from_page" 		value="<%=from_page%>">
  <table border='0' cellspacing='0' cellpadding='0' width='100%'>
  <tr> 
    <td class=line> 
      <table border=0 cellspacing=1 width=100%>
        <tr> 
          <td class=title width="30">연번</td>
          <td class=title width="70">구분</td>
          <td class=title width="120">계약번호</td>
          <td class=title>상호</td>
          <td class=title width="150">대여기간</td>
          <td class=title width="75">대여구분</td>
          <td class=title width="75">대여방식</td>		  
          <td class=title width="80">해지일자</td>		  
        </tr>
        <%//계약이력
			Vector rents = ai_db.getRentHisList(base.getCar_mng_id());
			int rent_size = rents.size();
			if(rent_size > 0){		
				for(int i = 0 ; i < rent_size ; i++){
				Hashtable rent = (Hashtable)rents.elementAt(i);%>
        <tr> 
          <td align="center"><%=i+1%></td>
          <td align="center"><%=rent.get("USE_YN")%></td>
          <td align="center"><%=rent.get("RENT_L_CD")%></td>
          <td align="center"><%=rent.get("FIRM_NM")%></td>
          <td align="center"><%=rent.get("RENT_START_DT")%>~<%=rent.get("RENT_END_DT")%></td>
          <td align="center"><%=rent.get("CAR_ST")%></td>
          <td align="center"><%=rent.get("RENT_WAY")%></td>		  
          <td align="center"><%=rent.get("CLS_DT")%></td>		  
        </tr>
        <%		}%>
        <%	}%>
		<%	sBean = olsD.getSui(base.getCar_mng_id());
			if(!sBean.getMigr_dt().equals("")){%>
        <tr> 
          <td class=title width="30">연번</td>
          <td class=title width="70">구분</td>
          <td class=title width="120">-</td>
          <td class=title>계약자</td>
          <td class=title width="150">연락처</td>
          <td class=title width="75">계약일자</td>
          <td class=title width="75">매매대금</td>		  
          <td class=title width="80">명의이전일</td>		  
        </tr>
        <tr> 
          <td align="center">-</td>
          <td align="center">명의이전</td>
          <td align="center">-</td>
          <td align="center"><%=sBean.getSui_nm()%></td>
          <td align="center"><%=sBean.getH_tel()%>,<%=sBean.getM_tel()%></td>
          <td align="center"><%=AddUtil.ChangeDate2(sBean.getCont_dt())%></td>
          <td align="center"><%=AddUtil.parseDecimal(sBean.getMm_pr())%>원</td>		  
          <td align="center"><%=AddUtil.ChangeDate2(sBean.getMigr_dt())%></td>		  
        </tr>		
        <%	}%>		
      </table>
    </td>
  </tr>
  </table>
</form>
</body>
</html>
