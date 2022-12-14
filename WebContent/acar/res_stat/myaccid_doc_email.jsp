<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.io.*, acar.util.*, acar.res_search.*, acar.car_register.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean"       scope="page"/>
<%
	String l_cd	 =	 request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String m_id	 =	 request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String s_cd	 =	 request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id	 =	 request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String d_car_no = "";
	
	//현재날짜 FETCH
	Calendar cal = Calendar.getInstance(); 
    String curY = String.valueOf(cal.get(Calendar.YEAR));
    String curM = String.valueOf(cal.get(Calendar.MONTH)+1);	//Calendar Class는 Month에 +1.
    String curD = String.valueOf(cal.get(Calendar.DATE));
    if(Integer.parseInt(curM)<10){		curM = "0"+curM;	 }
    if(Integer.parseInt(curD)<10){		curD = "0"+curD;	 }
    
    //이메일 발송용 기본정보 FETCH
    //단기대여관리 수정
	RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);
	//고객정보
	RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id(), rc_bean.getSite_id());
	//사고차량정보
	CarRegDatabase crd 	= CarRegDatabase.getInstance();
	cr_bean = crd.getCarRegBean(rc_bean.getSub_c_id());
%>

<html>
<head><title>아마존카 - 대차료 동의서 안내문 및 위임장</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<style>

@page a4sheet { size: 21.0cm 29.7cm }

.a4 { page: a4sheet; page-break-after: always }

</style>
<script language='javascript'>
<!--
	function pagesetPrint(){
		var userAgent = navigator.userAgent.toLowerCase();
		if (userAgent.indexOf("edge") > -1) {
			window.print();
		} else if (userAgent.indexOf("whale") > -1) {
			window.print();
		} else if (userAgent.indexOf("chrome") > -1) {
			window.print();
		} else if (userAgent.indexOf("firefox") > -1) {
			window.print();
		} else if (userAgent.indexOf("safari") > -1) {
			window.print();
		} else {
			IE_Print();
		}
// 		IEPageSetupX.header='';
// 		IEPageSetupX.footer='';
// 		IEPageSetupX.leftMargin=12;
// 		IEPageSetupX.rightMargin=12;
// 		IEPageSetupX.topMargin=20;
// 		IEPageSetupX.bottomMargin=20;
// 		print();
	}
	
function IE_Print(){
	factory1.printing.header='';
	factory1.printing.footer='';
	factory1.printing.leftMargin=12;
	factory1.printing.rightMargin=12;
	factory1.printing.topMargin=20;
	factory1.printing.bottomMargin=20;
	factory1.printing.Print(true, window);
}
-->
</script>
</head>
<body leftmargin="10" topmargin="1" onLoad="javascript:pagesetPrint()" >
<!-- <OBJECT id=IEPageSetupX classid="clsid:41C5BC45-1BE8-42C5-AD9F-495D6C8D7586" codebase="/pagesetup/IEPageSetupX.cab#version=1,0,18,0" width=0 height=0>	 -->
<!-- 	<param name="copyright" value="http://isulnara.com"> -->
<!-- </OBJECT> -->
<object id=factory1 style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>
<form action="" name="form1" method="POST" >					
<!-- 업무협조 의뢰 문서 -->					
<div class="a4">					
  <table width='640' height="" border="0" cellpadding="0" cellspacing="0">
    <tr> 
        <td colspan="2" height="40" align="center" style="font-size : 18pt;"><b><font face="바탕">주식회사 아마존카</font></b>
		</td>
		<tr>
		<td height="25" align="center" style="font-size : 9pt;"><font face="바탕">우150-874 서울특별시 영등포구 의사당대로 8, 태흥빌딩 8층 802호 (여의도동) 전화:02)392-4243 팩스:0505-361-9355</font>
		</td>
    </tr>
     <tr> 
      <td colspan="2" height="4" align="center" bgcolor=000000></td>
    </tr>
	<tr> 
      <td colspan="2" height="20" align="center"></td>
    </tr>
  
    <tr> 
      <td height="125" colspan="2" align='center'> <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td width="10%" height="25" style="font-size : 10pt;"><font face="바탕">문서번호</font></td>
            <td width="3%" height="25" style="font-size : 10pt;"><font face="바탕">:</font></td>
            <td height="25" width="87%" style="font-size : 10pt;"><font face="바탕">
              </font></td>
          </tr>
          <tr> 
            <td height="25" style="font-size : 10pt;"><font face="바탕">발신일자</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕">:</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕"><%=curY%>년 <%=curM%>월 <%=curD%>일</font></td>
          </tr>
          <tr> 
            <td height="25" style="font-size : 10pt;"><font face="바탕">수&nbsp;&nbsp;&nbsp;&nbsp;신</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕">:</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕"><%=rc_bean2.getCust_nm()%></font></td>
          </tr>
          <tr> 
            <td height="25" style="font-size : 10pt;"><font face="바탕">발&nbsp;&nbsp;&nbsp;&nbsp;신</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕">:</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕">(주)아마존카 대표 조성희</font></td>
          </tr>
		  <tr> 
            <td height="25" style="font-size : 10pt;"><font face="바탕"></font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕"></font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕">(총무팀장 이사 안보국 담당자 장혁준 02-6263-6383)</font></td>
          </tr>
          <tr> 
            <td height="25" style="font-size : 10pt;"><font face="바탕">제&nbsp;&nbsp;&nbsp;&nbsp;목</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕">:</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕">업무협조의뢰</font></td>
          </tr>
        
        </table></td>
    </tr>
    <tr> 
      <td height="7" colspan="2" align='center'></td>
    </tr>
    <tr bgcolor="#999999"> 
      <td colspan=2 align='center' height="2" bgcolor="#333333"></td>
    </tr>
    <tr> 
      <td height="30" colspan="2" align='center'></td>
    </tr>  
    <tr>
        <td align=center>
            <table width=628 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td height="30" style="font-size : 10pt;"><font face="바탕">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1. 귀사의 무궁한 발전을 기원합니다.</font></td>
                </tr>
				<tr>
                    <td height=20></td>
                </tr>
                
                <tr>
                   <td height="30" style="font-size : 10pt;">
                   		<font face="바탕">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2. 
				   과거 <%if(!cr_bean.getCar_no().equals("")){%><%=cr_bean.getCar_no()%><%}else{%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%}%> 차량의 피해사고로 인하여 당사는 귀사에게 대차차량을 제공한 바<br>
				   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;있습니다. 대차료는 원칙적으로 귀사가 가해차량 보험사에 청구를 하고, 이를 수령하여<br>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;당사에 지급하는것이 원칙입니다. 그러나 절차상의 번거로움을 줄이고자 당사가 귀사를<br> 
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;대위하여 직접 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;에 대차료를 청구한 것입니다.  </font></td>
                </tr>
				<tr>
                    <td height=20></td>
                </tr>
                <tr>
                   <td height="30" style="font-size : 10pt;"><font face="바탕">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3. 
				   그러나 법원에서 대위청구의 근거가 부족하다고 하여, 부득이하게 귀사에 업무협조를<br>
				   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 요청하게 되었습니다.</font></td>
                </tr>
				<tr>
                    <td height=20></td>
                </tr>
                <tr>
                   <td height="30" style="font-size : 10pt;"><font face="바탕">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4. 
				   동봉한 채권 양도 통지서 및 위임장에 서명 또는 날인하시고, 우편 또는 FAX로 발송하여<br>
				   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;주시기 바랍니다.<br>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(보내주신 서류는 법원에 증거제출로 사용될 뿐, 어떠한 다른 목적으로 사용되지 않을
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;것임을 약속 드립니다.)</font></td>
                </tr>
				<tr>
                    <td height=20></td>
                </tr>
                <tr>
                   <td height="30" style="font-size : 10pt;"><font face="바탕">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;5. 
				   기타 문의사항은 상기 전화번호로 문의하여 주시기 바랍니다.</font></td>
                </tr>
				<tr>
	                <td height=20></td>
	            </tr>
                <tr>
                    <td height="30" align="right" style="font-size : 10pt;"><font face="바탕">&nbsp;&nbsp;<span class=style7 style="margin-right: 20px;">-끝-</span></font></td>
                </tr>
	            <tr>
	                <td height=20></td>
	            </tr>
                <tr>
                    <td height="25" style="font-size : 10pt;"><font face="바탕">&nbsp;&nbsp;<span class=style7></span></font></td>
                </tr>
                <tr>
                    <td height=20></td>
                </tr>
                </table>
            </td>
        </tr>
		
    </td>
</tr>

</table>

<table width='640' height="70" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height=50></td>
	</tr>
    <tr> 
      <td colspan="2"><font face="바탕">&nbsp;</font></td>
    </tr>
    <tr align="center"> 
      <td height="40" colspan="2" style="font-size : 19pt;"><font face="바탕"><b>주식회사 
        아마존카 대표이사 조&nbsp;&nbsp;성&nbsp;&nbsp;희</b></font><IMG src='../../images/cust/3c7kR522I6Sqs_70.gif' style="position: absolute;;margin-top: -15px;"></td>
    </tr>
	<tr>
		<td height=20></td>
	</tr>
	<tr>
		<td height=20></td>
	</tr>
</table>
</div>

<!-- 채권 양도 통지서 및 위임장 -->
<div class="a4">
	<table width=628 border=0 cellspacing=0 cellpadding=0>
		<tr> 
			<td>
				<table width=100% border=1 cellspacing=0 cellpadding=0>
					<tr>
						<td colspan="2" height="60" align="center" style="font-size : 18pt;">
							<b><font face="바탕">채권 양도 통지서 및 위임장</font></b>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td height=30></td>
		</tr>
		<tr>
			<td>
				<table width=100% border=1 cellspacing=0 cellpadding=0>
					<tr>
						<td height="50" width="20%" style="font-size : 10pt;" align="center"><font face="바탕">수신처(채무자)</font></td>
						<td align="center" style="font-size : 10pt;"><font face="바탕">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 귀하</font></td>
					</tr>
				</table>
			</td>	
		</tr>
		<tr>
			<td height=10></td>
		</tr>
		<tr>
			<td>
				<table width=100% border=1 cellspacing=0 cellpadding=0>
					<tr>
					   <td height="40" width="10%" style="font-size : 10pt;" colspan="1" rowspan="2" align="center"><font face="바탕">발신처<br>(채권자)</font></td>
					   <td height="40" width="10%" style="font-size : 10pt;" align="center"><font face="바탕">성명/상호</font></td>
					   <td height="40" style="font-size : 10pt;" align="center"><%if(!rc_bean2.getFirm_nm().equals("") && !rc_bean2.getEnp_no().equals("")){%>
					   		<font face="바탕">&nbsp;&nbsp;<%=rc_bean2.getFirm_nm()%>&nbsp;(<%=AddUtil.ChangeEnt_no(rc_bean2.getEnp_no())%>)</font></td><%}%>
					</tr>
					<tr>
					   <td height="40" width="10%" style="font-size : 10pt;" align="center"><font face="바탕">주소</font></td>
					   <td height="40" style="font-size : 10pt;"><%if(!rc_bean2.getZip().equals("") && !rc_bean2.getAddr().equals("") && !rc_bean2.getCust_nm().equals("")){%>
					   		<font face="바탕">&nbsp;&nbsp;(<%=rc_bean2.getZip()%>) <%=rc_bean2.getAddr()%>&nbsp;대표이사 :&nbsp;<%=rc_bean2.getCust_nm()%></font><%}%>
					   </td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td height=10></td>
		</tr>
		<tr>
			<td>
				<table width=100% border=1 cellspacing=0 cellpadding=0>
					<tr>
					   <td height="40" width="10%" style="font-size : 10pt;" colspan="1" rowspan="2" align="center"><font face="바탕">채권의<br>내용</font></td>
					   <td height="40" width="10%" style="font-size : 10pt;" align="center"><font face="바탕">종류</font></td>
					   <td height="40" style="font-size : 10pt;" align="center"><font face="바탕">아래 사고 차량 수리기간 동안의 대차료(보험금)</font></td>
					</tr>
					<tr>
					   <td height="40" width="10%" style="font-size : 10pt;" align="center"><font face="바탕">금액</font></td>
					   <td height="40" style="font-size : 10pt;" align="center"><font face="바탕">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;원&nbsp;(\&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;)</font></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td height=10></td>
		</tr>
		<tr>
			<td>
				<table width=100% border=1 cellspacing=0 cellpadding=0>
					<tr>
					   <td height="40" width="10%" style="font-size : 10pt;" colspan="1" rowspan="2" align="center"><font face="바탕">사고<br>차량</font></td>
					   <td height="40" width="10%" style="font-size : 10pt;" align="center"><font face="바탕">차량번호</font></td>
					   <td height="40" style="font-size : 10pt;" align="center" width="35%"><font face="바탕"><%=cr_bean.getCar_no()%></font></td>
					   <td height="40" width="10%" style="font-size : 10pt;" align="center"><font face="바탕">사고일자</font></td>
					   <td height="40" style="font-size : 10pt;" align="center" width="35%"><font face="바탕"><%-- <%=AddUtil.ChangeDate2((String)ht.get("ACCID_DT"))%> --%></font></td>
					</tr>
					<tr>
					   <td height="40" width="10%" style="font-size : 10pt;" align="center"><font face="바탕">차명</font></td>
					   <td height="40" style="font-size : 10pt;" align="center" width="35%"><font face="바탕"><%=cr_bean.getCar_nm()%></font></td>
					   <td height="40" width="10%" style="font-size : 10pt;" align="center"><font face="바탕">수리기간</font></td>
					   <!--<td height="40" style="font-size : 10pt;" align="center"><font face="바탕"><%//=AddUtil.ChangeDate3(String.valueOf(reserv.get("DELI_DT"))))%>~<%//=AddUtil.ChangeDate3(String.valueOf(reserv.get("RET_DT")))%></font></td>-->
						<td height="40" style="font-size : 10pt;" align="center" width="35%"><font face="바탕"><%-- <%=AddUtil.ChangeDate3(String.valueOf(ht.get("USE_ST")))%> --%>~<%-- <%=AddUtil.ChangeDate3(String.valueOf(ht.get("USE_ET")))%> --%></font></td>
					</tr>
				</table>
			</td>
		</tr>
		
		<tr>
			<td height=10></td>
		</tr>
		<tr>
			<td>
				<table width=100% border=1 cellspacing=0 cellpadding=0>
					<tr>
					   <td height="40" width="10%" style="font-size : 10pt;" colspan="1" rowspan="2" align="center"><font face="바탕">양도할<br>내용</font></td>
					   <td height="40" width="10%" style="font-size : 10pt;" align="center"><font face="바탕">내역</font></td>
					   <td height="40" style="font-size : 10pt;" align="center"><font face="바탕">(주)아마존카에서 받은 사고대차 차량의 대차료(보험금) 채권 전액의 <br>청구 및 수령의 권한 및 권리</font></td>
					</tr>
					<tr>
					   <td height="40" width="10%" style="font-size : 10pt;" align="center"><font face="바탕">금액</font></td>
					   <td height="40" style="font-size : 10pt;" align="center"><font face="바탕">일금&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;원정&nbsp;(\&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;)</font></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td height=30></td>
		</tr>
		<tr>
		   <td height="20" style="font-size : 10pt; line-height:2;"><font face="바탕">상기 채권자 본인(아래 양도인)은 아래 양수인 (주)아마존카에게 상기 대차료(보험금)채권의 청구 및 수령의 권한 및 권리를 정상적이고 확정적으로 양도 및 승낙하였음을 통지합니다.</font></td>
		</tr>
		<tr>
			<td height=20></td>
		</tr>
		<tr>
			<td height="20" align="center" style="font-size : 10pt;"><font face="바탕">&nbsp;&nbsp;<span class=style7><%=curY%>.&nbsp;&nbsp;&nbsp;<%=curM%>.&nbsp;&nbsp;&nbsp;<%=curD%></span></font></td>
		</tr>
		<tr>
			<td height=20></td>
		</tr>
		<tr>
			<td>
				<table width=100% border=1 cellspacing=0 cellpadding=0>
					<tr>
					   <td height="40" width="10%" style="font-size : 10pt;" colspan="1" rowspan="2" align="center"><font face="바탕">양도인</font></td>
					   <td height="40" width="10%" style="font-size : 10pt;" align="center"><font face="바탕">성명</font></td>
					   <td height="40" style="font-size : 10pt;" align="right"><font face="바탕"> 
					   <%if(!rc_bean2.getCust_st().equals("개인")){%>
					   <%=rc_bean2.getFirm_nm()%> <%if(rc_bean2.getCust_st().equals("법인")){ %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>대표이사:&nbsp;<%} %>
					   <%}%>
					   <%=rc_bean2.getCust_nm()%>&nbsp;(인)&nbsp;</font></td>
					   <td height="40" width="20%" style="font-size : 10pt;" align="center"><font face="바탕"><%if(   rc_bean2.getCust_st().equals("개인")){%>생년월일<%}else{%>사업자등록번호<%}%></font></td>
					   <td height="40" width="20%"style="font-size : 10pt;" align="center"><font face="바탕"><%if(   rc_bean2.getCust_st().equals("개인")){%><%=AddUtil.subDataCut((rc_bean2.getSsn()+""),6)%><%}else{%><%=AddUtil.ChangeEnt_no(rc_bean2.getEnp_no())%><%}%></font></td>
					</tr>
					<tr>
					   <td height="40" width="10%" style="font-size : 10pt;" align="center"><font face="바탕">주소</font></td>
					   <td height="40" style="font-size : 10pt;" align="center" colspan="3"><%if(!rc_bean2.getZip().equals("")&& !rc_bean2.getAddr().equals("")){%>
					   		<font face="바탕">(<%=rc_bean2.getZip()%>) <%=rc_bean2.getAddr()%></font><%}%>
					   </td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td height=10></td>
		</tr>
		<tr>
			<td>
				<table width=100% border=1 cellspacing=0 cellpadding=0>
					<tr>
					   <td height="40" width="10%" style="font-size : 10pt;" colspan="1" rowspan="2" align="center"><font face="바탕">양수인</font></td>
					   <td height="40" width="10%" style="font-size : 10pt;" align="center"><font face="바탕">성명</font></td>
					   <td height="40" style="font-size : 10pt;" align="right"><font face="바탕">주식회사 아마존카&nbsp;(인)<IMG src='../../images/cust/3c7kR522I6Sqs_70.gif' style="position: absolute;width:40px;height:40px;margin-top: -15px;margin-left: -30px;">&nbsp;</font></td>
					   <td height="40" width="20%" style="font-size : 10pt;" align="center"><font face="바탕">법인등록번호</font></td>
					   <td height="40" width="20%" style="font-size : 10pt;" align="center"><font face="바탕">115611-0019610</font></td>
					</tr>
					<tr>
					   <td height="40" width="10%" style="font-size : 10pt;" align="center"><font face="바탕">주소</font></td>
					   <td height="40" style="font-size : 10pt;" align="center" colspan="3"><font face="바탕">(150-874)서울시 영등포구 의사당대로 8 태흥빌딩 8층</font></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td height=20></td>
		</tr>
		<tr>
		   <td height="20" style="font-size : 10pt; line-height:2;"><font face="바탕">※ 보험사와의 과실비용협의를 위함이고, 고객비용부담은 없는 사항입니다.</font></td>
		</tr>		
		<tr>
			<td height=10></td>
		</tr>
	</table>
</div>
<%-- 
 <% 	}
			} %> --%>

</form>
</body>
</html>
