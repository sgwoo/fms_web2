<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.cus0601.*" %>
<%@ page import="acar.util.*, acar.consignment.*, acar.user_mng.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="c61_soBn" class="acar.cus0601.ServOffBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function view_cons(cons_no, seq){
		var width 	= 800;
		var height 	= 700;		
		window.open("cons_reg_print.jsp?cons_no="+cons_no+"&seq="+seq+"&step=3", "Print", "left=10, top=10, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");		
	}

//-->
</script>
<link rel=stylesheet type="text/css" href="../../include/table.css">
<body>
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
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String off_id 	= request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String req_dt 	= request.getParameter("req_dt")==null?"":request.getParameter("req_dt");
	
	Vector vt = cs_db.getConsignmentNotPayOffList(off_id, req_dt);
	int vt_size = vt.size();
	
	Cus0601_Database c61_db = Cus0601_Database.getInstance();
	c61_soBn = c61_db.getServOff(off_id);
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3	= 0;
	long total_amt4 = 0;
	long total_amt5 = 0;

%>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 		value='<%=sort%>'>
  <input type='hidden' name="mode" 		value="<%=mode%>">
  <input type='hidden' name="from_page" value="<%=from_page%>">
  <input type='hidden' name='off_id' 	value='<%=off_id%>'>
  <input type='hidden' name='req_dt' 	value='<%=req_dt%>'>

  <table border="0" cellspacing="0" cellpadding="0" width=1320>
    <tr>
      <td>&lt; 탁송료 청구 리스트 &gt; </td>
    </tr>  
    <tr>
      <td>&nbsp;</td>
    </tr>  
    <tr>
      <td class=line><table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width="10%" class=title>탁송업체</td>		  
          <td width="23%" align='center'><%=c61_soBn.getOff_nm()%></td>
          <td width="10%" class=title>거래은행</td>
          <td width="23%" align='center'><%=c61_soBn.getBank()%></td>
          <td width="10%" class=title>계좌번호</td>
          <td align='center'><%=c61_soBn.getAcc_no()%></td>
        </tr>
        <tr>
		  <td class=title>청구일자</td>
          <td align='center'><%=AddUtil.ChangeDate2(req_dt)%></td>
          <td class=title>총건수</td>
          <td align='center'><%=vt_size%>건</td>
          <td class=title>총청구금액</td>
          <td align='center'><input type='text' name="req_amt" value='' size='10' class='whitenum' readonly>원</td>
        </tr>
      </table></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>  
	<tr>
	  <td class=line>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		  <tr valign="middle" align="center"> 
		    <td width='30' rowspan="2" class=title>연번</td>
		    <td width='80' rowspan="2" class=title>탁송사유</td>
		    <td width='90' rowspan="2" class=title >차량번호</td>
		    <td width='100' rowspan="2" class=title>차명</td>
		    <td colspan="2" class=title>출발</td>
		    <td colspan="2" class=title>도착</td>
		    <td width="60" rowspan="2" class=title>운전자</td>
		    <td width="60" rowspan="2" class=title>의뢰자</td>
		    <td colspan="6" class=title>청구금액</td>
	      </tr>
		  <tr valign="middle" align="center">
		    <td width='110' class=title>지점</td>		  
		    <td width='130' class=title>시간</td>		  
		    <td width='110' class=title>지점</td>		  
		    <td width='130' class=title>시간</td>		  
		    <td width='70' class=title>탁송료</td>
		    <td width='60' class=title>유류비</td>
		    <td width='60' class=title>세차비</td>
		    <td width='80' class=title>기타내용</td>			
		    <td width='60' class=title>기타금액</td>
		    <td width='80' class=title>소계</td>
		  </tr>
<%		for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>
		  <tr> 
		    <td align='center'><%=i+1%></td>
		    <td align='center'><%=ht.get("CONS_CAU_NM")%></td>
		    <td align='center'><a href="javascript:view_cons('<%=ht.get("CONS_NO")%>','<%=ht.get("SEQ")%>')"><%=ht.get("CAR_NO")%></a></td>
		    <td align='center'><%=ht.get("CAR_NM")%></td>			
		    <td align='center'><span title='<%=ht.get("FROM_PLACE")%>'><%=Util.subData(String.valueOf(ht.get("FROM_PLACE")), 6)%></span></td>
		    <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("FROM_DT")))%></td>			
		    <td align='center'><span title='<%=ht.get("TO_PLACE")%>'><%=Util.subData(String.valueOf(ht.get("TO_PLACE")), 6)%></span></td>
		    <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("TO_DT")))%></td>			
		    <td align='center'><%=ht.get("DRIVER_NM")%></td>			
		    <td align='center'><%=ht.get("USER_NM1")%></td>
		    <td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CONS_AMT")))%></td>
		    <td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("OIL_AMT")))%></td>			
		    <td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("WASH_AMT")))%></td>
		    <td align='center'><%=ht.get("OTHER")%></td>			
		    <td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("OTHER_AMT")))%></td>
		    <td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TOT_AMT")))%></td>
		  </tr>
  <%		total_amt1 	= total_amt1 + Long.parseLong(String.valueOf(ht.get("CONS_AMT")));
			total_amt2 	= total_amt2 + Long.parseLong(String.valueOf(ht.get("OIL_AMT")));
			total_amt3 	= total_amt3 + Long.parseLong(String.valueOf(ht.get("WASH_AMT")));
			total_amt4 	= total_amt4 + Long.parseLong(String.valueOf(ht.get("OTHER_AMT")));
			total_amt5 	= total_amt5 + Long.parseLong(String.valueOf(ht.get("TOT_AMT")));
		  }%>
				<tr>
					<td class="star">&nbsp;</td>
					<td class="star">&nbsp;</td>					
					<td class="star">&nbsp;</td>
					<td class="star">&nbsp;</td>
					<td class="star">&nbsp;</td>					
					<td class="star">&nbsp;</td>										
					<td class="star">&nbsp;</td>	
					<td class="star">&nbsp;</td>
					<td class="star">&nbsp;</td>					
					<td class="star">&nbsp;</td>															
					<td align='right' class="star"><%=Util.parseDecimal(total_amt1)%></td>
					<td align='right' class="star"><%=Util.parseDecimal(total_amt2)%></td>					
					<td align='right' class="star"><%=Util.parseDecimal(total_amt3)%></td>															
					<td class="star">&nbsp;</td>					
				    <td align='right' class="star"><%=Util.parseDecimal(total_amt4)%></td>
				    <td align='right' class="star"><%=Util.parseDecimal(total_amt5)%></td>
				</tr>		  
	    </table>
	  </td>
	</tr>
	<tr>
		<td>
		  <a href="javascript:print()">인쇄</a>&nbsp;&nbsp;
		  <a href="#">지급처리</a>&nbsp;&nbsp;
		  <a href="javascript:window.close();" onMouseOver="window.status=''; return true">닫기</a>
		</td>	
	</tr>	
	<tr>
		<td>
		  <font color=#CCCCCC>※인쇄TIP : A3, 가로방향</font>
		</td>	
	</tr>		
  </table>
  <input type='hidden' name='cons_amt' 	value='<%=total_amt1%>'>
  <input type='hidden' name='oil_amt' 	value='<%=total_amt2%>'>
  <input type='hidden' name='wash_amt' 	value='<%=total_amt3%>'>
  <input type='hidden' name='other_amt' value='<%=total_amt4%>'>
  <input type='hidden' name='tot_amt' 	value='<%=total_amt5%>'>        
</form>  
<script language='javascript'>
<!--
	document.form1.req_amt.value = '<%=Util.parseDecimal(total_amt5)%>';
//-->
</script>
</body>
</html>
