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
	
	if(car_name.equals("��ü")) 	car_name = "";
	if(car_name.equals("����")) 	car_name = "";
	if(view_dt.equals("��ü")) 	view_dt = "";
	if(view_dt.equals("����")) 	view_dt = "";
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
           ó������ : I ���׷��̵�
        </td>
    </tr>
    <tr>
        <td>            
            <table border=1 cellspacing=1 width=100%>
			  <tr>
			    <td width="30" rowspan="2" align="center">����</td>
			    <td width="150" rowspan="2" align="center">������</td>
			    <td width="150" rowspan="2" align="center">����</td>
			    <td width="300" rowspan="2" align="center">��</td>
			    <td width="100" rowspan="2" align="center">�⺻����</td>
			    <td width="60" rowspan="2" align="center">���ڵ�</td>				
			    <td width="60" rowspan="2" align="center">�Ϸù�ȣ</td>		
				<td colspan="3" align="center">����</td>
				<td width="50" rowspan="2" align="center">�߰�<br>��<br>����</td>												
			    <td width="60" rowspan="2" align="center">�����ڵ�</td>												
			    <td width="100" rowspan="2" align="center">��������</td>
			    <td width="60" rowspan="2" align="center">��뿩��</td>		
			    <td width="100" rowspan="2" align="center">��������<br>(����ǥ����<br>������)</td>
			    <td width="200" rowspan="2" align="center">���</td>
				<% 	for(int j=0; j<max_opt_cnt; j++){%>		
			    <td colspan="3" align="center">���û��<%=j+1%></td>
				<%	}%>
				<td width="60" rowspan="2" align="center">���û��<br>����</td>
				<td width="70" rowspan="2" align="center">���û��<br>�ѱݾ�</td>
			  </tr>
			  <tr>
			    
				<td width="200" align="center">����</td>		
				<td width="100" align="center">���ڵ�</td>		
				<td width="100" align="center">�Ϸù�ȣ</td>		
				
			    <% 	for(int j=0; j<max_opt_cnt; j++){%>		
			    <td width="50" align="center">��ȣ</td>
			    <td align="center">����</td>
		        <td width="100" align="center">�ݾ�</td>
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
				<td align="center"><%=co_r.length%>��</td>
				<td align="right"><%=total_amt1%></td>
				<!-- �߰�Į�� -->
								
			  </tr>
			  <%}%>			  
            </table>
        </td>
    </tr>
</table>
</body>
</html>