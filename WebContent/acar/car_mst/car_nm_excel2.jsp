<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>  

<%@ page import="java.util.*, acar.util.*, acar.car_mst.*" %> 
<%@ include file="/acar/cookies.jsp" %>

<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename="+AddUtil.getDate(4)+"_car_nm_excel2.xls");
%>

<%
	String car_comp_id = request.getParameter("car_comp_id")==null?"0001":request.getParameter("car_comp_id");
	String car_cd = request.getParameter("car_cd")==null?"":request.getParameter("car_cd");
	String car_name = request.getParameter("car_name")==null?"":request.getParameter("car_name");
	String view_dt = request.getParameter("view_dt")==null?"":request.getParameter("view_dt");
	
	if(car_name.equals("전체")) 	car_name = "";
	if(car_name.equals("선택")) 	car_name = "";
	if(view_dt.equals("전체")) 	view_dt = "";
	if(view_dt.equals("선택")) 	view_dt = "";
	if(view_dt.equals("99999999")) 	view_dt = "";
	if(!car_name.equals(""))	view_dt = "";
	
	AddCarMstDatabase a_cmd = AddCarMstDatabase.getInstance();
	
	Vector vt = a_cmd.getCarNmExcelList2(car_comp_id, car_cd, car_name, view_dt);
	int vt_size = vt.size();
	
	int max_opt_cnt = 20;

%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=7250>
    <tr>
        <td colspan='78'>
           처리구분 : I 업그레이드
        </td>
    </tr>
    <tr>
        <td>            
            <table border=1 cellspacing=1 width=100%>
			  <tr>
			    <td width="30" rowspan="2" align="center">연번</td>
			    <td width="150" rowspan="2" align="center">제조사</td>
			    <td width="150" rowspan="2" align="center">차명</td>
			    <td width="300" rowspan="2" align="center">모델</td>
			    <td width="100" rowspan="2" align="center">기본가격</td>
			    <td width="60" rowspan="2" align="center">모델코드</td>				
			    <td width="60" rowspan="2" align="center">일련번호</td>		
				<td colspan="3" align="center">변동</td>
				<td width="50" rowspan="2" align="center">추가<br>및<br>삭제</td>												
			    <td width="60" rowspan="2" align="center">차종코드</td>												
			    <td width="100" rowspan="2" align="center">기준일자</td>
			    <td width="60" rowspan="2" align="center">사용여부</td>		
			    <td width="100" rowspan="2" align="center">단종일자<br>(가격표에서<br>빠진날)</td>
			    <td width="200" rowspan="2" align="center">비고</td>
				<% 	for(int j=0; j<max_opt_cnt; j++){%>		
			    <td colspan="3" align="center">선택사양<%=j+1%></td>
				<%	}%>
				<td width="60" rowspan="2" align="center">선택사양<br>갯수</td>
				<td width="70" rowspan="2" align="center">선택사양<br>총금액</td>
			  </tr>
			  <tr>
			    
				<td width="200" align="center">사유</td>		
				<td width="100" align="center">모델코드</td>		
				<td width="100" align="center">일련번호</td>		
				
			    <% 	for(int j=0; j<max_opt_cnt; j++){%>		
			    <td width="50" align="center">번호</td>
			    <td align="center">구분</td>
		        <td width="100" align="center">금액</td>
				<%	}%>				
			  </tr>
			  <%for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
					CarOptBean [] co_r = a_cmd.getCarOptList(String.valueOf(ht.get("CAR_COMP_ID")), String.valueOf(ht.get("CAR_CD")), String.valueOf(ht.get("CAR_ID")), String.valueOf(ht.get("CAR_SEQ")), "");
					int total_amt1	= 0;
					%>
			  <tr>
			    <td  align="center"><%=i+1%></td>
			    <td ><%=ht.get("NM")%></td>
			    <td ><%=ht.get("CAR_NM")%></td>
			    <td ><%=ht.get("CAR_NAME")%></td>
			    <td  align="right"><%=ht.get("CAR_B_P")%></td>
			    <td  align="center">'<%=ht.get("CAR_ID")%></td>
			    <td  align="center">'<%=ht.get("CAR_SEQ")%></td>	
				
				<td></td>
				<td></td>
				<td></td>
				
				<td>I</td>			
			    <td  align="center"><%=ht.get("JG_CODE")%></td>
			    <td  align="center"><%=ht.get("CAR_B_DT")%></td>
			    <td  align="center"><%=ht.get("USE_YN")%></td>		
				<td align="center"><%=ht.get("END_DT")%></td>
				<td>&nbsp;</td>				
				<% 	for(int j=0; j<co_r.length; j++){
        				CarOptBean co_bean = co_r[j];
						total_amt1 += co_bean.getCar_s_p();%>
			    <td>'<%=co_bean.getCar_s_seq()%></td>
				<td><%=co_bean.getCar_s()%></td>
			    <td  align="right"><%=co_bean.getCar_s_p()%></td>
				<%	}
					if(co_r.length < max_opt_cnt){
						for(int k=co_r.length; k<max_opt_cnt; k++){%>
			    <td>&nbsp;</td>
			    <td>&nbsp;</td>				
			    <td>&nbsp;</td>						
				<%		}
					}%>
				<td align="center"><%=co_r.length%>개</td>
				<td align="right"><%=total_amt1%></td>
				<!-- 추가칼럼 -->
								
			  </tr>
			  <%}%>			  
            </table>
        </td>
    </tr>
</table>
</body>
</html>