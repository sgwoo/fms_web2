<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.car_mst.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>


<%
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//행수
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//열수
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//시작행
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//실제데이타있는행수
	
	String off_id 	 = request.getParameter("off_id")==null?"":request.getParameter("off_id");	//공통-업체코드
	
	String result[]  = new String[value_line+10];
	String value0[]  = request.getParameterValues("value0");//제조사
	String value1[]  = request.getParameterValues("value1");//출고사무소
	String value2[]  = request.getParameterValues("value2");//성명
	String value3[]  = request.getParameterValues("value3");//생년월일
	String value4[]  = request.getParameterValues("value4");//전화번호
	String value5[]  = request.getParameterValues("value5");
	String value6[]  = request.getParameterValues("value6");
	String value7[]  = request.getParameterValues("value7");
	String value8[]  = request.getParameterValues("value8");
	String value9[]  = request.getParameterValues("value9");
	String value10[] = request.getParameterValues("value10");
	String value11[] = request.getParameterValues("value11");
	String value12[] = request.getParameterValues("value12");
	String value13[] = request.getParameterValues("value13");
	String value14[] = request.getParameterValues("value14");
	String value15[] = request.getParameterValues("value15");
	String value16[] = request.getParameterValues("value16");
	String value17[] = request.getParameterValues("value17");
	String value18[] = request.getParameterValues("value18");
	String value19[] = request.getParameterValues("value19");
	
	String car_comp_nm 	= "";
	String dlv_ext 		= "";
	String man_nm 		= "";
	String man_ssn 	 	= "";
	String man_tel 	 	= "";
	boolean flag = true;
	
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	
	for(int i=start_row ; i < value_line ; i++){
	
		car_comp_nm = value0[i] ==null?"":AddUtil.replace(value0[i],"㈜","");
		dlv_ext 	= value1[i] ==null?"":value1[i];
		man_nm		= value2[i] ==null?"":value2[i];
		man_ssn 	= value3[i] ==null?"":value3[i];
		man_tel		= value4[i] ==null?"":value4[i];
		
		String car_comp_id	= a_cmb.getCarCompCd(car_comp_nm);
				
		flag = cs_db.insertConsCostMan(off_id, car_comp_id, dlv_ext, man_nm, man_ssn, man_tel);
		
		if(flag){
			result[i] = "정상처리";
		}else{
			result[i] = "에러발생";
		}
	}
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<script language="JavaScript" src="/include/info.js"></script>
</HEAD>
<BODY>
<table border="0" cellspacing="0" cellpadding="0" width="570">
  <tr>
    <td>&lt; 엑셀 파일 처리 결과(에러) &gt; </td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>      
  <tr>
    <td class="line">
	  <table border="0" cellspacing="1" cellpadding="0" width=100%>  
        <tr>
    	  <td width="30" class="title">연번</td>
    	  <td width="100" class="title">차량코드</td>
    	  <td width="100" class="title">차량번호</td>
    	  <td class="title">처리결과</td>
        </tr>
<%	for(int i=start_row ; i < value_line ; i++){
		if(result[i].equals("정상처리.")) continue;%>		
        <tr>
          <td align="center"><%=i+1%></td>
          <td align="center"><%=value0[i] ==null?"":value0[i]%></td>
          <td align="center"><%=value1[i] ==null?"":value1[i]%></td>
          <td>&nbsp;<%=result[i] ==null?"":result[i]%></td>		  
        </tr>
<%	}%>		
	  </table>
	</td>
  </tr>  
</table>
</BODY>
</HTML>