<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.account.*" %>
<%@ include file="/acar/cookies.jsp" %>


<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<script language="JavaScript">
<!--
	function ForfeitReg(car_mng_id,rent_mng_id,rent_l_cd){
		var theForm = document.ForfeitRegForm;
		theForm.car_mng_id.value = car_mng_id;
		theForm.rent_mng_id.value = rent_mng_id;
		theForm.rent_l_cd.value = rent_l_cd;
		theForm.target="d_content"
		theForm.submit();
	}
//-->
</script>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String gubun1 = request.getParameter("gubun1")==null?"3":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	AddForfeitDatabase a_fdb = AddForfeitDatabase.getInstance();
	Vector fines = a_fdb.getFineStat(gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, s_kd, t_wd);
	int fine_size = fines.size();
%>
<table border="0" cellspacing="0" cellpadding="0" width=820>
	<tr>
        <td>
            <table border=0 cellspacing=1 width="820">
            	<tr>
            		<td align="right" width="801">
					<%	if(auth_rw.equals("R/W")){%>            		
            			<a href="./forfeit_i_frame.jsp" target="d_content">입력</a>
					<%	}%>            		
            		</td>
            		<td width=19>&nbsp;
					</td>
            	</tr>
            </table>
        </td>
    </tr>	
	<tr>
		<td>
			 <table border="0" cellspacing="1" cellpadding="0" width=800>
				<tr>
					<td><iframe src="./forfeit_sc_in.jsp?auth_rw=<%=auth_rw%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&sort_gubun=<%=sort_gubun%>&asc=<%=asc%>" name="ExpList" width="800" height="300" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
				</tr>							

			</table>
		</td>
	</tr>

    <tr>
        <td>
	        <table border=0 cellspacing=0 cellpadding=0 width=800>
	        	<tr>
	        		<td>< 검색통계 ></td>
	        	</tr>
	        	<tr>
	    		    
          <td class=line> 
            <table width="800" border="0" cellspacing="1" cellpadding="0">
              <tr align="center"> 
                <td colspan="2" rowspan="2" class='title'>구분</td>
                <td colspan="2" class='title'>당월</td>
                <td colspan="2" class='title'>당일</td>
                <td colspan="2" class='title'>연체</td>
                <td colspan="2" class='title'>합계</td>
              </tr>
              <tr align="center"> 
                <td width="70" class='title'>건수</td>
                <td width="100" class='title'>금액</td>
                <td width="70" class='title'>건수</td>
                <td width="100" class='title'>금액</td>
                <td width="70" class='title'>건수</td>
                <td width="100" class='title'>금액</td>
                <td width="70" class='title'>건수</td>
                <td class='title'>금액</td>
              </tr>
              <%	if(fine_size > 0){
		for (int i = 0 ; i < fine_size ; i++){
			IncomingBean fine = (IncomingBean)fines.elementAt(i);%>
              <tr> 
                <%if(!fine.getGubun_sub().equals("N")){
				if(i == 0 || i == 2 || i ==4){%>
                <td width="45" align="center" class='title' rowspan="2"><%=fine.getGubun()%></td>
                <td width="45" align="center" class='title'><%=fine.getGubun_sub()%></td>
                <%	}else{%>
                <td width="45" align="center" class='title'><%=fine.getGubun_sub()%></td>
                <%	}
			  }else{%>
                <td width="90" align="center" class='title' colspan="2"><%=fine.getGubun()%></td>
                <%}%>
                <td width="70" align="right"><%=fine.getTot_su1()%> 
                  <%if(fine.getGubun().equals("비율")) {%>
                  %
                  <%}else{%>
                  건
                  <%}%>
                  &nbsp; </td>
                <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(fine.getTot_amt1()))%> 
                  <%if(fine.getGubun().equals("비율")){%>
                  %
                  <%}else{%>
                  원
                  <%}%>
                  &nbsp; </td>
                <td width="70" align="right"><%=fine.getTot_su2()%> 
                  <%if(fine.getGubun().equals("비율")){%>
                  %
                  <%}else{%>
                  건
                  <%}%>
                  &nbsp; </td>
                <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(fine.getTot_amt2()))%> 
                  <%if(fine.getGubun().equals("비율")){%>
                  %
                  <%}else{%>
                  원
                  <%}%>
                  &nbsp; </td>
                <td width="70" align="right"><%=fine.getTot_su3()%> 
                  <%if(fine.getGubun().equals("비율")){%>
                  %
                  <%}else{%>
                  건
                  <%}%>
                  &nbsp; </td>
                <td width="100" align="right"><%=Util.parseDecimal(String.valueOf(fine.getTot_amt3()))%> 
                  <%if(fine.getGubun().equals("비율")){%>
                  %
                  <%}else{%>
                  원
                  <%}%>
                  &nbsp; </td>
                <td width="70" align="right"> 
                  <%if(!fine.getGubun().equals("비율")){%>
                  <%=fine.getTot_su2()+fine.getTot_su3()%>건
                  <%}else{%>
                  -&nbsp;
                  <%}%>
                  &nbsp; </td>
                <td align="right"> 
                  <%if(!fine.getGubun().equals("비율")){%>
                  <%=Util.parseDecimal(String.valueOf(fine.getTot_amt2()+fine.getTot_amt3()))%>원
                  <%}else{%>
                  -&nbsp;
                  <%}%>
                  &nbsp; </td>
              </tr>
              <%		}
	}else{%>
              <tr> 
                <td colspan="10" align="center">자료가 없습니다.</td>
              </tr>
              <%	}%>
            </table>
          </td>
				</tr>
			</table>
		</td>
    </tr>
</table>
<form action="./forfeit_i_frame.jsp" name="ForfeitRegForm" method="post">
<input type="hidden" name="car_mng_id" value="">
<input type="hidden" name="rent_mng_id" value="">
<input type="hidden" name="rent_l_cd" value="">
<input type="hidden" name="cmd" value="">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="st" value="<%=st%>">
<input type="hidden" name="f_st" value="<%=f_st%>">
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="gubun_nm" value="<%=gubun_nm%>">
<input type="hidden" name="s_year" value="<%=s_year%>">
</form>
</body>
</html>