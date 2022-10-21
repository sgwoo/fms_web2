<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, java.text.*"%>
<%@ page import="acar.util.*, acar.user_mng.*, acar.insur.* "%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	
	InsDatabase ai_db = InsDatabase.getInstance();
		
	Vector vt  = new Vector();
	

	if(!t_wd.equals("")){
		vt = ai_db.getInsComEmpInfo3(t_wd, s_kd); 
	}

	int vt_size = vt.size();
	 Date d = new Date();
	 SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	 String sysdate =   sdf.format(d);	
	
	
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script src='/include/common.js'></script>
<script>

	/* Title 고정 */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	}
	
	function init() {
		setupEvents();
	}
	
	//전체선택
	function AllSelect(){
		var fm = document.form1;
		var len = fm.ch_cd.length;
		var cnt = 0;
		var idnum ="";
		var allChk = fm.ch_all;
		 for(var i=0; i<len; i++){
			var ck = fm.ch_cd[i];			
			 if(allChk.checked == false){
				ck.checked = false;
			}else{
				ck.checked = true;
			} 
		} 
	}	
	
	function selectOne(reg_code){
		parent.parent.location.href = '/acar/ins_mng/ins_calc_reg.jsp?reg_code='+reg_code;
	}
	
	function regInsCost(reg_code, ins_cost){
		var fm = document.form1;
		location.href = '/acar/ins_mng/ins_calc_reg_a.jsp?reg_code='+reg_code+'&req_st=c&ins_cost='+ins_cost;
	}
	
	function regInsCostBtn(reg_code, k){
		var fm = document.form1;
		<%-- var vt_size = '<%=vt_size%>'; --%>
		var ins_cost = "";
		if(vt_size == 1) 
			ins_cost = fm.ins_cost.value;
		else 
			ins_cost = fm.ins_cost[k].value;
		
		regInsCost(reg_code, ins_cost);	
	}
	
	function sendconfirm(reg_code, ins_cost, car_name, reg_id){
		var req_st ='f';
		if(confirm("완료 하시겠습니까?") == true){
			var fm = document.form1;
			parent.parent.location.href = '/acar/ins_mng/ins_calc_reg_a.jsp?reg_code='+reg_code+'&req_st='+req_st+'&car_name2='+car_name+'&reg_id='+reg_id+'&ins_cost='+ins_cost;
		}else{
			return;			
		}
	}
	
	function onKeyDown(reg_code, ins_cost){
		regInsCost(reg_code, ins_cost);	
	}
	
	function onlyNumber(event){
		event = event || window.event;
		var keyID = (event.which) ? event.which : event.keyCode;
		if ( (keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105) || keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ) 
			return;
		
	}
	function removeChar(event) {
		event = event || window.event;
		var keyID = (event.which) ? event.which : event.keyCode;
		if ( keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ) 
			return;
		else
			event.target.value = event.target.value.replace(/[^0-9]/g, "");
	}
	function numberComma(x){
		var fm = document.form1;
		fm.ins_cost.value= x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}
	
	function selectOne(client_id){
		parent.parent.location.href = '/acar/ins_mng/ins_emp_detail.jsp?client_id='+client_id;
	}
	function printDirect(client_id){
		var fm = document.form1;
		var url = "ins_u_sh_emp_print2.jsp";
		window.open("" ,"popForm", 
		      "left=500, top=50, width=800, height=900, scrollorbars=yes"); 
		fm.action =url; 
		fm.method="post";
		fm.target="popForm";
		fm.client_id.value=client_id;
		fm.submit();
	}

</script>
</head>
<body onLoad="javascript:init()">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 	value='<%=sort%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/ins_com/ins_com_new_frame.jsp'>
  <input type='hidden' name='seq' value=''>
  <input type='hidden' name='size' value=''>
  <input type='hidden' name='req_st' value=''>
  <input type='hidden' name='client_id' value=''>
  <input type='hidden' name='base_year' value='<%=Integer.parseInt(sysdate.substring(0,4))-1%>'>
  <br>
 <table border="0" cellspacing="0" cellpadding="0" width='1200'>
     <tr>
        <td colspan="2" class=line2></td>
    </tr> 
    <tr id='tr_title' style='position:relative;z-index:1'>
	<td class='line' width='1200'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%' height="100%">
		<tr>
		    <td width='10' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
		    <td width='20' class='title'>연번</td>
		    <td width='80' class='title'>상호</td>
		    <td width='40' class='title'>대표자</td>
		    <td width='60' class='title'>사업자번호</td>
		    <td width='200' class='title'>차량번호</td>
		    <td width='30' class='title'>사용차량수</td>
		    <td width='20' class='title'>인쇄</td>
		</tr>
	    </table>
	</td>
    </tr>
     <%	if(vt_size > 0){%>
    <tr>
     	<td class='line' >
	    <table border="0" cellspacing="1" cellpadding="0" width='100%' height="100%">
		<%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				
				//차량정보
				Vector vt2 = ai_db.getInsComEmpInfo4(String.valueOf(ht.get("CLIENT_ID")),""); 
				int vt2_size = vt2.size();
				String car_no_list = "&nbsp;&nbsp;";
				for(int j = 0 ; j < vt2_size ; j++){
					if(j>6 && j%7 == 0) car_no_list +="<br>&nbsp;&nbsp;";
					Hashtable ht2 = (Hashtable)vt2.elementAt(j);
					car_no_list +=  ht2.get("CAR_NO") +"&nbsp;&nbsp;" ;
				}
				
				if(vt2_size <= 0) continue; 
		%>			
		<tr>
		   <tr>
		    <td width='10' align='center'><input type="checkbox" name="ch_cd" value="<%=ht.get("CLIENT_ID")%>"></td>
		    <td width='20' align='center'><%=count+1%></td>
		    <td width='80' align='center'><a href="javascript:selectOne('<%=ht.get("CLIENT_ID")%>');"><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 12)%></a></td>
		    <td width='40' align='center'><%=Util.subData(String.valueOf(ht.get("CLIENT_NM")), 3)%></td>
		    <td width='60' align='center'><%=ht.get("ENP_NO1")%><%=ht.get("ENP_NO2")%>-<%=ht.get("ENP_NO3")%></td>
		    <td width='200' style=""><%=car_no_list %></td>
		    <td width='30' align='center'><%=vt2_size %></td>
		    <td width='20' align='center'><a href="javascript:printDirect('<%=ht.get("CLIENT_ID")%>');"><img src=/acar/images/center/button_print1.gif width=15 height=15></a></td>
		</tr>
		<%		count++;%>
		<%	}%>
	    </table>
		</td>
    </tr>
    <%	}else{%>   
    <tr>
	<td class='line' width='1200' id='td_con' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td align='center'>
		        <%if(t_wd.equals("")){%>검색어를 입력하십시오.
		        <%}else{%>등록된 데이타가 없습니다<%}%>
		    </td>
		</tr>
	    </table>
	</td>
    </tr>
    <%	}%> 
    <tr>
        <td colspan="2" class=line2></td>
    </tr> 
</table>
</form>
<script>
	parent.document.form1.size.value = '<%=count%>';
</script>
</body>
</html>

