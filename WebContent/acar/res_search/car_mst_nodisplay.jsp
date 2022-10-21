<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.car_mst.*" %>

<%
	AddCarMstDatabase a_cdb = AddCarMstDatabase.getInstance();
	
	String sel = request.getParameter("sel")==null?"":request.getParameter("sel");
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code = request.getParameter("code")==null?"":request.getParameter("code");
	String mode = "1";
	int count = 0;
	
	Vector cars = a_cdb.getSearchCode(car_comp_id, code, "", "", mode, "");
	int car_size = cars.size();
%>
<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	te = parent.<%=sel%>;

<%	if(car_size > 0){%>

	te.length = <%= car_size+1 %>;
	te.options[0].value = '';
	te.options[0].text = '선택';

<%		for(int i = 0 ; i < car_size ; i++){
			Hashtable car = (Hashtable)cars.elementAt(i);
			if(mode.equals("1")){%>
				te.options[<%=i+1%>].value = '<%=car.get("CODE")%>';
				te.options[<%=i+1%>].text = '[<%=car.get("CAR_CD")%>]<%=car.get("CAR_NM")%>';

<%			}else if(mode.equals("8")){%>	
				te.options[<%=i+1%>].value = '<%=car.get("CODE")%>';
				te.options[<%=i+1%>].text = '<%=car.get("CAR_NM")%>';

<%			}else if(mode.equals("2") || mode.equals("4")){%>	
				te.options[<%=i+1%>].value = '<%=car.get("CAR_ID")%>';
				te.options[<%=i+1%>].text = '<%=car.get("CAR_NAME")%>';

<%			}else if(mode.equals("3")){%>	
				te.options[<%=i+1%>].value = '<%=car.get("CAR_B_DT")%>';
				te.options[<%=i+1%>].text = ChangeDate('<%=car.get("CAR_B_DT")%>');

<%			}else if(mode.equals("10")){%>	
				te.options[<%=i+1%>].value = '<%=car.get("CAR_SEQ")%><%=car.get("CAR_ID")%>';
				te.options[<%=i+1%>].text = '<%=car.get("CAR_NAME")%>';

<%			}
		}
	}else{	%>
	
	te.length = 1;
	te.options[0].value = '';
	te.options[0].text = '선택';

<%	}	%>
//-->
</script>
</head>
<body>
</body>
</html>
