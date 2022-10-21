<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,  acar.condition.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%

	ConditionDatabase cdb = ConditionDatabase.getInstance();

	String auth_rw = "";
	
	String g_fm = "1";
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
		
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");  //메이커
	String code = request.getParameter("code")==null?"":request.getParameter("code");  //차종(차명)
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	
	String dt = request.getParameter("dt")==null?"2":request.getParameter("dt");
	String st_dt = request.getParameter("st_dt")==null?Util.getDate():request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?Util.getDate():request.getParameter("end_dt");

	Vector vt = cdb.getLoanCondAll(dt, st_dt, end_dt, gubun2, car_comp_id, code);
	int vt_size = vt.size();
	
	float loan_amt = 0;
	int loan_amt1 = 0;
		
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	//전체선택
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
	
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "cho_id"){		
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
<body>
<form name='form1'  method='post' target='d_content'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='car_comp_id' value='<%=car_comp_id%>'>
<input type='hidden' name='code' value='<%=code%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width=4%>연번</td>
                    <td class='title' width=4%><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
                    <td width=15% class='title'>차대번호</td>
                    <td width=10% class='title'>차량번호</td>
                    <td width=15% class='title'> 차종</td>    
                     <td width=10% class='title'> 연료</td>    
                    <td width=25% class='title'>상호</td>    
                    <td width=10% class='title'>계약구분</td>
                     <td width=10% class='title'>관리담당</td>
        
                </tr>
          <% 		for (int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);		
			// 추후 데이타 화 
		
		         loan_amt =  0;
		   
			
			loan_amt1 = (int) loan_amt;
			loan_amt1 = AddUtil.ten_th_rnd(loan_amt1);
		  %>	  
                <tr align="center"> 
                    <td><%=i+1%></td>
                    <td> 
                      <input type="checkbox" name="cho_id" value="<%=ht.get("RENT_MNG_ID")%>^<%=ht.get("RENT_L_CD")%>^<%=ht.get("CAR_MNG_ID")%>^<%=car_comp_id%>^">
                   </td>
                    <td><%=ht.get("CAR_NUM")%></td>
                    <td><%=ht.get("CAR_NO")%></td>   
                     <td><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 10)%></td>  
                     <td><%=ht.get("FUEL_KD")%></td> <!--연료 -->   
                      <td><span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 18)%></td>     
                    <td><%=ht.get("RENT_WAY_NM")%></td>
         		 <td><%=ht.get("MNG_NM")%></td>      
                </tr>
          <%		}%>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>
