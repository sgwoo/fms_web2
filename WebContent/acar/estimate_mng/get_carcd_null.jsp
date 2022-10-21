<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*, acar.car_office.*" %>

<%
	AddCarMstDatabase a_cdb = AddCarMstDatabase.getInstance();
	
	String sel = request.getParameter("sel")==null?"":request.getParameter("sel");
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code = request.getParameter("code")==null?"":request.getParameter("code");
	String car_id = request.getParameter("car_id")==null?"":request.getParameter("car_id");
	String view_dt = request.getParameter("view_dt")==null?"":request.getParameter("view_dt");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String rent_way = request.getParameter("rent_way")==null?"":request.getParameter("rent_way");
	String a_a = request.getParameter("a_a")==null?"":request.getParameter("a_a");
	int count = 0;
	
	CarOfficeDatabase umd   = CarOfficeDatabase.getInstance();
	
	Vector cars = a_cdb.getSearchCode(car_comp_id, code, car_id, view_dt, mode, a_a);
	int car_size = cars.size();
	int indexV = 0;

	//String etc = umd.getCarCompOne(car_comp_id);
	Hashtable com_ht = umd.getCarCompCase(car_comp_id);
	String etc 	= String.valueOf(com_ht.get("ETC"));
	String bigo = String.valueOf(com_ht.get("BIGO"));
%>
<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
	var etc = '<%=AddUtil.replace(etc,"\r\n","<br>")%>';
	te = parent.<%=sel%>;
	parent.form1.etc.value=replaceString("<br>","\r\n",etc);
	resize(parent.form1.etc);
	
	parent.form1.bigo.value='<%=bigo%>';
	
function resize(obj) {
  obj.style.height = "1px";
  obj.style.height = obj.scrollHeight;
}	

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
</script>
</head>
<body>
</body>
</html>
