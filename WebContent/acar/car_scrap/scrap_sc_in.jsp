<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_scrap.*"%>
<jsp:useBean id="sc_db" scope="page" class="acar.car_scrap.ScrapDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<script language="JavaScript" src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//차량번호 이력
	function car_no_history(car_no)
	{	
		window.open("./car_no_history.jsp?car_no="+car_no, "NO_HIS", "left=300, top=100, width=620, height=180");
	}	
//-->
</script>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String gubun = request.getParameter("gubun")==null?"서울":request.getParameter("gubun");
	int count =0;
	
	Vector scrs = sc_db.getScrapList(gubun, s_kd, t_wd);
	int scr_size = scrs.size();
	
		String query = "";
		query = " select max(a.car_mng_id) car_mng_id, a.car_no, c.car_nm from"+ 
				" (select DISTINCT b.car_no, a.car_mng_id from car_reg a, car_change b where a.car_mng_id=b.car_mng_id and a.car_no<>b.car_no) a,"+
				" car_reg b,"+ 
				" (select first_car_no, max(car_nm) car_nm from car_reg group by first_car_no) c"+
				" where a.car_no=b.car_no(+) and b.car_no is null and a.car_no=c.first_car_no"+
				" and a.car_no like '"+gubun+"%"+t_wd+"%'"+                
				" and a.car_no like '%허%' and substr(a.car_no, 3,2) in ('34','71')"+
				" and substr(a.car_no, 6,4) not in ('4333','4386','4455','4457','4462','4464','4465','4470','5826','3017')"+//20040427:감차차량번호 제외
				" group by a.car_no, c.car_nm "+
				" order by a.car_no";
//out.println(query);				
	
%>
<form action="" name="form1" method="post">
<input type="hidden" name="hol_size" value="<%=scr_size%>">
  <table border=0 cellspacing=0 cellpadding=0 width=500 >
    <tr>		
    <td height="20" > 
        <table border="0" cellspacing="0" cellpadding="0" width=500>
          <tr>					
          <td class='line' width="800"> 
              <table  border=0 cellspacing=1 width="500">
                <%if(scr_size > 0){
					for(int i =0; i < scr_size ; i++){
						Hashtable scr = (Hashtable)scrs.elementAt(i);
						if(sc_db.getInsertYn(String.valueOf(scr.get("CAR_NO"))) != 0) continue;%>
                <tr> 
                  <td align="center" width="40"><%=count+1%></td>
                  <td align="center" width="160"><a href="javascript:car_no_history('<%=scr.get("CAR_NO")%>');"><%=scr.get("CAR_NO")%></a></td>
                  <td align="center"><%=scr.get("CAR_NM")%></td>
                  <td align="center" width="100"><%=sc_db.getEnd_cha_dt((String)scr.get("CAR_MNG_ID"), "")%></td>                  
                </tr>
                <%	count ++;
					}%>
                <%}else{%>
                <tr> 
                  <td colspan="3" align="center">등록된 자료가 없습니다.</td>
                </tr>
                <%}%>
              </table>
		  </td>
		  <td width=19>&nbsp;</td>
		</tr>
	  </table>
	</td>
  </tr>	
</table>
</form>
</body>
</html>
