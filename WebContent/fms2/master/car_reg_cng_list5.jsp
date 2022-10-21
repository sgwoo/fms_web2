<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*,acar.common.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	
	String car_ext 		= request.getParameter("car_ext5")	==null?"":request.getParameter("car_ext5");
	int car_cnt 		= request.getParameter("car_cnt5")	==null?0:AddUtil.parseDigit(request.getParameter("car_cnt5"));
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String s_dt	 	= request.getParameter("s_dt")		==null?"":request.getParameter("s_dt");
	String car_use	 	= request.getParameter("car_use5")	==null?"":request.getParameter("car_use5");
	String car_fuel 	= request.getParameter("car_fuel")	==null?"":request.getParameter("car_fuel");
		
	Vector vt = ad_db.getCarExtCngExcelList5(car_ext, car_use, st_dt, end_dt, s_dt, car_fuel);
	int vt_size = vt.size();
	
	if(car_cnt > 0 && vt_size > car_cnt) vt_size = car_cnt;
	

  //차량등록지역
  CodeBean[] code32 = c_db.getCodeAll3("0032");
  int code32_size = code32.length;	
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
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_cd"){		
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}
		}
	}
	
	//변경하기
	function save(){
		var fm = document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					idnum=ck.value;
					cnt++;					
				}
			}
		}	
		if(cnt == 0){
		 	alert("변경할 차량을 선택하세요.");
			return;
		}	
		if(fm.cng_car_ext.value == '')	{ alert('이관할 지역을 선택하십시오.'); return; }
		if(fm.cng_dt.value == '')		{ alert('이관일자를 입력하십시오.'); 	return; }		
//		fm.target = "i_no";
		
		fm.action = "car_reg_cng_list_a2.jsp";
		fm.submit();	
	}								
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='' method='post'>
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <input type='hidden' name='car_ext' value='<%=car_ext%>'>
  <input type='hidden' name='st_dt' value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' value='<%=end_dt%>'>
  <table border="0" cellspacing="0" cellpadding="0" width=850>
	<tr>
	  <td colspan="7" align="center"><%=c_db.getNameByIdCode("0032", "", car_ext)%> 지역번호 사용본거지 이관 리스트 <%if(car_cnt>0){%>(<%=car_cnt%>대)<%}%></td>
	</tr>		
	<tr>
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>	  
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>	  	  	  	  
	  <td>&nbsp;</td>	  	  	  	  	  
	</tr>		
	<tr>
	  <td colspan="7">
	    ▣ 이관할 지역 :
	    <select name="cng_car_ext">
	    	
                    	  <%for(int i = 0 ; i < code32_size ; i++){
                            CodeBean code = code32[i];%>
                        <option value='<%= code.getNm_cd()%>' <%if("6".equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>  
	  </select>&nbsp;&nbsp;&nbsp;
	  ▣ 이관일자 : 
	  <input type='text' name='cng_dt' size='12' value='' class='text'>
	  &nbsp;&nbsp;&nbsp;
	  ▣ 이관사유 : 
	  <input type='text' name='cng_cau' size='40' value='' class='text'>
	  &nbsp;&nbsp;&nbsp;
	  <a href="javascript:save();" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>
	  </td>
	</tr>				
	<tr>
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>	  
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>	  	  	  	  
	  <td>&nbsp;</td>	  	  	  	  	  
	</tr>		
	<tr>
	  <td width="50" class="title">연번</td>
	  <td width="50" class="title"><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>	  
	  <td width="100" class="title">관리번호</td>
	  <td width="150" class="title">전차량번호</td>
	  <td width="150" class="title">변경차량번호</td>
	  <td width="200" class="title">차명</td>
	  <td width="150" class="title">최초등록일</td>			
	</tr>
	<%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
	<input type='hidden' name='car_mng_id' value='<%=ht.get("CAR_MNG_ID")%>'>		
	<tr>
	  <td align="center"><%=i+1%></td>
	  <td align='center'><input type="checkbox" name="ch_cd" value="<%=i%>"></td>
	  <td align="center"><%=ht.get("CAR_DOC_NO")%></td>
	  <td align="center"><%=ht.get("CAR_NO")%></td>	  
	  <td align="center"><input type='text' name='car_no' value='<%=ht.get("CAR_NO")%>' size='10'></td>
	  <td align="center"><%=ht.get("CAR_NM")%></td>
	  <td align="center"><%=ht.get("INIT_REG_DT")%></td>
	</tr>
	<%	}%>
  </table>
</form>
<script language='javascript'>
<!--
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
