<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*, acar.memo.*,acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript'>
	function save(work_st)
	{
		var fm = document.form1;
		
		if(work_st == '') { alert('무엇을 작업합니까? 알 수 없습니다.'); return;}
		
		
		if(work_st == 'search5'){
			fm.action = 'car_reg_cng_excel_list5.jsp';
		}else if(work_st == 'search5_2'){
			fm.action = 'car_reg_cng_excel_list5_2.jsp';
		}else if(work_st == 'search5_3'){
			fm.action = 'car_reg_cng_excel_list5_3.jsp';
		}else if(work_st == 'reg6'){
			if(fm.car_ext5.value == ''){ alert('등록지역을 선택하십시오.'); return;}		
			fm.action = 'car_reg_cng_list5.jsp';	
		}else if(work_st == 'down'){
			if(fm.car_ext5.value == ''){ alert('등록지역을 선택하십시오.'); return;}		
			fm.action = 'car_reg_print_all.jsp';		
		}
			
		fm.work_st.value = work_st;
		fm.target = '_blank';
		fm.submit();
	}
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
  CommonDataBase c_db = CommonDataBase.getInstance();

  //차량등록지역
  CodeBean[] code32 = c_db.getCodeAll3("0032");
  int code32_size = code32.length;	
%>
<form name='form1' action='' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='work_st' value=''>
<div class="navigation">
	<span class="style1">차량관리 > 차량등록관리 ></span><span class="style5"></span>
</div>
<div class="content">
	<table class="inner-table">
		<colgroup>
	   		<col width="5%"/>
	   		<col width="*"/>
	   	</colgroup>
	   	<thead>
	   		<tr>
	   			<td class="line" colspan="2" style="background-color:#b0baec;padding:0px;height:2;"></td>
	   		</tr>
	   	</thead>
	   	<tbody>
	   		<tr>
	   			<th rowspan="2">1</th>
	   			<td class="search-area">
	   				<label><i class="fa fa-check-circle"></i>등록지역</label>
	   				<select class="select" name="car_ext5" style="width:80px;">
	   					<option value="">전체</option>
                    	  <%for(int i = 0 ; i < code32_size ; i++){
                            CodeBean code = code32[i];%>
                        <option value='<%= code.getNm_cd()%>'><%= code.getNm()%></option>
                        <%}%>
	   				</select>
	   				&nbsp;&nbsp;&nbsp;
	   				<label>개수제한</label>
	   				<input type="text" class="input" name="car_cnt5" style="width:50px;">개
	   				&nbsp;&nbsp;&nbsp;
	   				<label>기간검색</label>
	   				<select name="s_dt" class="select" style="width:120px;">
                	  	<option value="b.init_reg_dt" selected>최초등록일</option>
                		<option value="b.car_end_dt" >차령종료일</option>
                	</select>                	                  	  
					<input type='text' size='11' name='st_dt' class='input' value=''>
                                ~ 
					<input type='text' size='11' name='end_dt' class='input' value=''>
				</td>
			</tr>
			<tr>
				<td>
					<b>현재</b> 
                	<select name="car_use5" class="select">
                	  	<option value="">선택</option>
                	  	<option value="1" selected>영업용</option>
                		<option value="2">자가용</option>
                	</select>&nbsp;&nbsp;                	  
                	<select name="car_fuel" class="select">
                	  	<option value="">선택</option>
                	  	<option value="2">전체</option>
                	  	<option value="1" selected>경유차량제외</option>
                	  	<option value="3">경유차량</option>
                	</select>
                	<b>차량</b> 리스트 <font color=red>조회</font> : 엑셀파일 열기 
					&nbsp;<input type="button" class="button" value="조회" onclick="save('search5')">&nbsp;
					&nbsp;<input type="button" class="button" value="외부제출용1 조회" onclick="save('search5_2')">&nbsp;
					&nbsp;<input type="button" class="button" value="외부제출용2 조회" onclick="save('search5_3')">(서울시청차고지감면율 조정)
					&nbsp;<input type="button" class="button" value="등록증출력" onclick="save('down')">
	   			</td>
	   		</tr>
	   		<tr>
	   			<th>2</th>
	   			<td>
	                1번 등록지역 차량 리스트 조회하여 차량번호/사용본거지 일괄 <font color=red>변경</font> : JSP파일을 이용하여 변경하기 &nbsp;
	                <input type="button" class="button" value="변경" onclick="save('reg6')">
	   			</td>
	   		</tr>
	   	</tbody>
	</table>
</div>

	        </table>
	    </td>
    </tr>
    <tr>
	    <td>&nbsp;</td>
    </tr>
    <tr>
	    <td>&nbsp;</td>
    </tr>
  
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
