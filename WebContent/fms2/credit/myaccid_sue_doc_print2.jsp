<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.io.*, acar.cont.*, acar.util.*, acar.common.*, acar.forfeit_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>

<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	String mode = request.getParameter("mode")==null?"0":request.getParameter("mode");
	
	String m_id = "";//계약관리번호
	String l_cd = "";//계약번호
	String c_id = "";//자동차관리번호
	String accid_id = "";//사고관리번호
			
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	
	String short_nm= c_db.getNameById(FineDocBn.getGov_id(), "INS_COM");	
	String firm_nm = "";
		
	Vector vt = FineDocDb.getMyAccidDocLists_2(doc_id);
	int vt_size = vt.size();		
	//내용 라인수
	int tot_size =  vt.size();
				
	int app_doc_h = 0;
	String app_doc_v = "";
			
	int line_h = 32;
	//페이지 길이
	int page_h = 850;
	//각 테이블 기본 길이
	int table1_h = 315+120;
	int table2_h = tot_size*line_h;	
	int table3_h = app_doc_h+140;
	
	//출력페이지수 구하기
	int page_cnt = ((table1_h+table2_h+table3_h)/page_h);
	if((table1_h+table2_h+table3_h)%page_h != 0) page_cnt = page_cnt + 1;
	
	//마지막 테이블 길이 구하기
	int height = (page_h*page_cnt)-(table1_h+table2_h);	
		
         int t_amt = 0;  
         
         String  req_dt = "";
         
        
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript" type="text/JavaScript">	

	function onprint(){
		factory.printing.header 	= ""; //폐이지상단 인쇄
		factory.printing.footer 	= ""; //폐이지하단 인쇄
		factory.printing.portrait 	= true; //true-세로인쇄, false-가로인쇄    
		factory.printing.leftMargin 	= 10.0; //좌측여백   
		factory.printing.rightMargin 	= 10.0; //우측여백
		factory.printing.topMargin 	= 10.0; //상단여백    
		factory.printing.bottomMargin 	= 10.0; //하단여백
		factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
	}

</script>
<style>
	*{font-family:dotum;}
	.one{line-height:22pt;}
	.two{line-height:22pt; font-size:11pt;}
	.red{color:black; }
	.red1{color:black;  font-weight:bold;}
	.list{font-size:10pt; text-align:center; font-weight:bold;}
	.line{font-weight:bold; text-decoration:underline;}
	.line1{font-weight:normal; text-decoration:underline;}
</style>
</head>
<body onLoad="javascript:onprint();">
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>

<form action="" name="form1" method="POST" >
<table width='640' height="<%=table1_h%>" border="0" cellpadding="0" cellspacing="0"  align=center>
	<tr>
		<td height=70></td>
	</tr>
	<tr> 
      	<td height="40" align="center" style="font-size : 23pt;"><b>소&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;장</b></td>
    </tr>
    <tr> 
      	<td height="60"></td>
    </tr>
    <tr> 
      	<td align=center> 
      		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="one">
          		<tr> 
		            <td width="14%" height="25" valign=top>원&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 고</td>
		            <td width="3%" height="25" valign=top>:</td>
		            <td height="25" width="84%"> 주식회사 아마존카 <br>대표이사 조 성 희</td>
		      	</tr>
		      	<tr>
		      		<td height=20></td>
		      	</tr>
		      	<tr> 
		            <td height="25" valign=top>피&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 고</td>
		            <td height="25" valign=top>:</td>
		            <td height="25"><%=FineDocBn.getGov_nm()%></td>
		      	</tr>
		     	</tr>
        	</table>
        </td>
    </tr>
    <tr>
    	<td height=30></td>
    </tr>
    <tr bgcolor="#000000"> 
      	<td height="2"></td>
    </tr>
    <tr>
    	<td height=60></td>
    </tr>
<% 	
		
           if(vt_size > 0){
			for(int i=0; i<vt.size(); i++){ 
				Hashtable ht = (Hashtable)vt.elementAt(i);
				
				if ( i < 1) {
					firm_nm= String.valueOf(ht.get("FIRM_NM"));
				}
				
				
				if(AddUtil.parseInt(String.valueOf(ht.get("AMT5")))==0){
					ht.put("AMT5", String.valueOf(ht.get("AMT3")));						
				}
				
				t_amt +=AddUtil.parseInt(String.valueOf(ht.get("AMT3")));
				
				req_dt = String.valueOf(ht.get("RENT_START_DT"));
			}
			
			//마지막 청구일자 + 1	
			req_dt = c_db.addDay(req_dt, 1);
	}				
%>	         
		    
    
    <tr>
    	<td style="font-size:12pt; font-weight:bold;" class="one">대차료 차액 청구의 소<br> 청구금액 : 금 <%=Util.parseDecimal(t_amt)%> 원정</td>
    </tr>
    <tr> 
      	<td height="80" colspan="2" align='center'></td>
    </tr>
    <tr>
    	<td>
    		<table width="50%" border="0" cellspacing="1" cellpadding="7" bgcolor=#000000>
    			<tr>
    				<td bgcolor=#FFFFFF width="45%" align=center height=42>소 가</td>
    				<td bgcolor=#FFFFFF align=right><%=Util.parseDecimal(t_amt)%>  원 </td>
    			</tr>
    			<tr>
    				<td bgcolor=#FFFFFF align=center height=42>첨부할 인지액</td>
    				<td bgcolor=#FFFFFF align=right><%=Util.parseDecimal(FineDocBn.getAmt1())%> 원 </td>
    			</tr>
    			<tr>
    				<td bgcolor=#FFFFFF align=center height=42>첨부한 인지액</td>
    				<td bgcolor=#FFFFFF align=right><%=Util.parseDecimal(FineDocBn.getAmt1())%> 원 </td>
    			</tr>
    			<tr>
    				<td bgcolor=#FFFFFF align=center height=42>송 달 료</td>
    				<td bgcolor=#FFFFFF align=right><%=Util.parseDecimal(FineDocBn.getAmt2())%> 원 </td>
    			</tr>
    			<tr>
    				<td bgcolor=#FFFFFF align=center height=60>비 고</td>
    				<td bgcolor=#FFFFFF align=right>인 </td>
    			</tr>
    		</table>
    	</td>
    </tr>
    <tr> 
      	<td height="170"></td>
    </tr>
    <tr align="center"> 
      	<td height="40" style="font-size : 20pt;"><b>서 울 남 부 지 방 법 원 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 귀  중</b></td>
    </tr>    
</table>

<p style='page-break-before:always'><br style="height:0; line-height:0"></P>
<table width='640' height="<%=table1_h%>" border="0" cellpadding="0" cellspacing="0" align=center>

	<tr>
		<td height=50></td>
	</tr>
	<tr> 
      	<td height="40" align="center" style="font-size : 23pt;"><b>소&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;장</b></td>
    </tr>
    <tr> 
      	<td height="60"></td>
    </tr>
    <tr> 
      	<td align=center> 
      		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="one">
          		<tr> 
		            <td width="14%" height="25" valign=top>원&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 고</td>
		            <td width="3%" height="25" valign=top>:</td>
		            <td height="25" width="84%"> 주식회사 아마존카 (115611-0019610)<br>서울시 영등포구 의사당대로 8 까뮤이앤씨빌딩 8층<br>대표이사 조 성 희</td>
		      	</tr>
		      	<tr>
		      		<td height=20></td>
		      	</tr>
		      	<tr> 
		            <td height="25" valign=top>피&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 고</td>
		            <td height="25" valign=top>:</td>
		            <td height="25"><%=FineDocBn.getGov_nm()%><br><%=FineDocBn.getGov_addr()%><br><%=FineDocBn.getMng_dept()%></td>
		      	</tr>
		     	</tr>
        	</table>
        </td>
    </tr>
    <tr>
    	<td height=30></td>
    </tr>
    <tr bgcolor="#000000"> 
      	<td height="2"></td>
    </tr>
    <tr>
    	<td height=60></td>
    </tr>
      <tr>
    	<td style="font-size:12pt; font-weight:bold;" class="one">대차료 차액 청구의 소<br> 청구금액 : 금 <%=Util.parseDecimal(t_amt)%> 원정</td>
    </tr>
    <tr> 
      	<td height="100"></td>
    </tr>
    <tr>
    	<td align=center style="font-size : 17pt; font-weight:bold;">-------&nbsp; 청&nbsp;&nbsp;&nbsp; 구&nbsp;&nbsp;&nbsp; 취&nbsp;&nbsp;&nbsp; 지 &nbsp;-------</td>
    </tr>
    <tr> 
      	<td height="50"></td>
    </tr>
    <tr>
    	<td>
    		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="one">
			    <tr> 
			      	<td>1. 피고는 원고에게 금 <%=Util.parseDecimal(t_amt)%>원 및 이에 대하여, 최후 청구 다음날인 <span class=red1> <%=AddUtil.ChangeDate2(req_dt)%></span>부터  이 사건 소장부본 송달일까지는 연 5%의, 그 다음날부터 다 갚는 날까지는 연 20%의 각 비율에 의한 금원을 지급하라.</td>
			    </tr>
			    <tr>
			    	<td height=25></td>
			    </tr>
			    <tr> 
			      	<td>2. 소송비용은 피고들이 부담한다.</td>
			    </tr>
			    <tr>
			    	<td height=25></td>
			    </tr>
			    <tr> 
			      	<td>3. 제1항은 가집행할 수 있다.</td>
			    </tr>
			    <tr>
			    	<td height=25></td>
			    </tr>
			    <tr> 
			      	<td>라는 판결을 구합니다.</td>
			    </tr>
			</table>
		</td>
	</tr>
</table>

<p style='page-break-before:always'><br style="height:0; line-height:0"></P>
<table width='640' height="<%=table1_h%>" border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td height=20></td>
	</tr>
    <tr>
    	<td align=center style="font-size : 17pt; font-weight:bold;">-------&nbsp; 청&nbsp;&nbsp;&nbsp; 구&nbsp;&nbsp;&nbsp; 원&nbsp;&nbsp;&nbsp; 인 &nbsp;-------</td>
    </tr>
    <tr> 
      	<td height="50"></td>
    </tr>
    <tr>
    	<td>
    		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="two">
			    <tr> 
			      	<td style="font-weight:bold; font-size:14pt;" colspan="2">Ⅰ. <span class=line>당사자들의 지위 및 사건의 경위</span></td>
			    </tr>
			    <tr>
			    	<td height=25></td>
			    </tr>
			    <tr> 
			      	<td style="font-weight:bold;" colspan="2">1. <span class=line>당사자들의 지위</span></td>
			    </tr>
			    <tr>
			    	<td height=15></td>
			    </tr>
			    <tr> 
			      	<td colspan="2">원고는 자동차 대여업, 중고차 매매업, 자동차 관련 종합정보제공업 등을 주요 사업으로 영위하는 회사이며, <span class=red>피고 <%=FineDocBn.getGov_nm()%>(이하 “<%=short_nm%>”라고 합니다)는 자동차보험업 등을 주로 영위하는 법인</span>입니다.</td>
			    </tr>
			    <tr>
			    	<td height=25></td>
			    </tr>
			    <tr> 
			      	<td style="font-weight:bold;" colspan="2">2. <span class=line>사건의 경위</span></td>
			    </tr>
			    <tr>
			    	<td height=15></td>
			    </tr>
			    <tr> 
			      	<td style="font-weight:bold;" colspan="2">가. <span class=line>원고와 각 렌트이용고객들간의 자동차대여계약의 체결</span></td>
			    </tr>
			    <tr>
			    	<td height=15></td>
			    </tr>
			    <tr> 
			      	<td colspan="2">원고는, 소외 <span class=red> “<%=firm_nm%>”외 <%=vt_size -1 %>개 업체</span>와 장기대여계약을 각 체결하였고, 다음의 각 계약에 따라 아래 업체에 각 자동차를 대여해 주었습니다. (<span class=red>갑 제1호 내지 제 <%=vt_size%>호</span>의 각 자동차대여이용계약서 참조). 이를 표로 정리하면 다음과 같습니다.</td>
			    </tr>
			    <tr>
			    	<td style="font-size : 10pt;">&nbsp;[표1]</td>
			    	<td style="font-size : 10pt;" align=right>(단위 : 원)&nbsp;</td>
			    </tr>
			    <tr>
			    	<td colspan="2">
			    		<table width=100% border=0 cellspacing=1 cellpadding=0 bgcolor=#000000 class="list">
			    			<tr bgcolor=#FFFFFF>
			    				<td rowspan="2" width="3%">순<br>번</td>
			    				<td rowspan="2" width="25%">상호</td>
			    				<td rowspan="2">계약일</td>
			    				<td colspan="3" height=30>대여이용계약기간</td>
			    				<td rowspan="2">선수금</td>
			    				<td rowspan="2">월대여료</td>
			    			</tr>
			    			<tr bgcolor=#FFFFFF>
			    				<td class="list" height=30>개시일</td>
			    				<td>종료일</td>
			    				<td>비고</td>
			    			</tr>
			    			
 <% 							
            if(vt_size > 0){
				for(int i=0; i<vt.size(); i++){ 
					
					Hashtable ht = (Hashtable)vt.elementAt(i);					
						
					%>					    			
			    	
			    	<tr class=red bgcolor=#FFFFFF>
				            <td height=30><%=i+1%></td>
				            <td><%=ht.get("FIRM_NM")%></td>	
				            <td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT2")))%></td>
				            <td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("V_RENT_START_DT")))%></td>
				            <td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("V_RENT_END_DT")))%></td>	
				            <td><%=ht.get("CON_MON")%>개월</td>	
				            <td align='right'><%=Util.parseDecimal(ht.get("GRT_AMT"))%>&nbsp;</td> 
				            <td align='right'><%=Util.parseDecimal(ht.get("FEE_AMT"))%>&nbsp;</td>					    
				 </tr>
		      <% 	}
	} %>
 		</table>
			    	</td>
			    </tr>
			    <tr>
			    	<td height=15></td>
			    </tr>
			    <tr> 
			      	<td colspan="2">한편 위 각 자동차대여이용계약서에서는 차량관리서비스 중 사고대차서비스가 일부 포함되어 있으나, <span class=line>만일 이용고객이 피해사고를 당하였을 경우에는 사고대차서비스를 제공하지 않는 것으로 명시되어 있었습니다.</span> 특히, 이 사건 각 자동차대여계약에서 이 사건 렌트이용고객들이 피해자인 피해사고의 경우에 원고가 사고대차서비스[무상]를 제공하지 않는 이유는 상대방의 과실로 유발된 사고의 경우 위 사고로 인한 피해는 상대방인 가해자(또는 가해자가 가입한 보험회사)가 자신의 비용과 책임으로 위 비용을 배상하는 것은 당연할 뿐만 아니라 렌터카이용고객이 아무런 과실이 없는 경우까지 렌트회사인 원고가 손해를 감수하면서까지 렌터카이용고객에게 위 사고대차서비스를 해 줄 어떠한 이유도 없기 때문입니다.</td>
			    </tr>
			    <tr>
			    	<td height=25></td>
			    </tr>
			    <tr> 
			      	<td colspan="2" style="font-weight:bold;">나. <span class=line>상대방 과실로 인한 자동차충돌사고의 발생</span></td>
			    </tr>
			    <tr>
			    	<td height=15></td>
			    </tr>
			    <tr> 
			      	<td colspan="2">그런데 원고로부터 각 자동차를 대여받은 이 사건 렌트이용고객들이 이 사건 각 자동차 장기대여 계약에 따라 위 각 자동차를 이용하던 중, 상대방의 100% 또는 쌍방 과실로 유발된 자동차충돌사고가 각 발생하였고, 결국 이 사건 렌트이용고객들은 렌트한 자동차를 상당한 기간 동안 이용하지 못하여 다른 차량을 대차하여야 하는 피해를 입게 되었습니다.</td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">한편, 위 각 사고에서의 가해자들은 모두 <%=short_nm%>보험에 가입하고 있었는 바, 각 개별사고를 표로 정리하면 다음과 같습니다.</td>
			    </tr>
			    <tr>
			    	<td height=25></td>
			    </tr>
			    <tr>
			    	<td style="font-size : 10pt;">&nbsp;[표2]</td>
			    	<td style="font-size : 10pt;" align=right>&nbsp;</td>
			    </tr>	   				
			
			   <tr>
			    	<td colspan="2">
			    		<table width=100% border=0 cellspacing=1 cellpadding=0 bgcolor=#000000 class="list">
			    			<tr bgcolor=#FFFFFF>
			    				<td width="15%">순번</td>
			    				<td width="35%">피해자</td>
			    				<td>피해차량번호</td>
			    				<td height=30>사고발생일</td>
			    			</tr>

 <% 							
            if(vt_size > 0){
				for(int i=0; i<vt.size(); i++){ 
					
					Hashtable ht = (Hashtable)vt.elementAt(i);					
			
					%>					    			
			    	
					    	<tr class=red bgcolor=#FFFFFF>
						            <td height=30><%=i+1%></td>
						            <td><%=ht.get("FIRM_NM")%></td>	
						             <td><%=ht.get("OUR_CAR_NO")%></td>	
						            <td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ACCID_DT")))%></td>
						    			    
						 </tr>
		      <% 	}
	} %>
			    		</table>
			    	</td>
			    </tr>
			    
			     <tr>
			    	<td colspan="2">  1)현재 원고 회사는 위 각 가해자들의 인적사항을 파악하지 못하여 위 각 가해자들을 특정하기는 어려운 상황입니다.</td>
			    </tr>
			     <tr>
			    	<td height=25></td>
			    </tr>
			    <tr>
			    	<td colspan="2" style="font-weight:bold;">다. <span class=line>원고의 피고들에 대한 대차료 상당의 보험료 청구</span></td>
			    </tr>
			    <tr>
			    	<td height=15></td>
			    </tr>
			    <tr>
			    	<td colspan="2">이에 피해자인 이 사건 렌트이용고객들은 원고 회사에게는 사고대차(사고가 난 차량이 수리를 받는 동안 그 차량을 대체할 새로운 차량의 렌트)를 요청하였고 원고는 이 사건 렌트이용고객에게 사고차량과 동종 또는 동급의 차량을 유상으로 대차(단기 렌트)제공하면서<span class=line>[사고대차서비스의 범위 제외]</span> 각 세금계산서를 발행하였습니다.</td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2"> 이후 원고는 가해자의 보험사인 피고에게, 피해자인 이 사건 렌트이용고객을 대위하여 급부의 편의를 위하여 <span class=line>사고대차료에 해당하는 손해금액에 대하여 보험금의 지급을 요청</span>하였습니다[다시 말해서, 이는 원칙적으로 각 렌트카이용고객들이 각 피고보험회사에게 직접 청구하여 위 보험금을 수령한 후 다시 원고에게 위 대차료를 지급하여야 하는 것이 원칙이나, 
			    	통상적인 보험금 청구와 마찬가지로 급부의 편의를 위하여 원고가 이를 일괄하여 청구한 것입니다]. 그러나 피고는 원고에게 <span class=line>원고가 청구하는 대차료에 상당하는 금액이 아닌 휴차료에 상당하는 금액만을 지급하고 있는 바,</span> 그 청구금액, 청구일자, 지급일자 등은 아래 표와 같습니다.</td>
			    </tr>
			    <tr>
			    	<td height=25></td>
			    </tr>
			    
			       <tr>
			    	<td style="font-size : 10pt;">&nbsp;[표3]</td>
			    	<td style="font-size : 10pt;" align=right>(단위 : 원)&nbsp;</td>
			    </tr>
			    <tr>
			    	<td colspan="2">
			    		<table width=100% border=0 cellspacing=1 cellpadding=0 bgcolor=#000000 class="list">
			    			<tr bgcolor=#FFFFFF>
			    				<td width="4%">순<br>번</td>
			    				<td width="25%">피해차량</td>
			    				<td>대차<br>차량</td>
			    				<td height=40>과실비율<br>(가해자)</td>
			    				<td>청구<br>일자</td>
			    				<td>청구액</td>
			    				<td>입금<br>일자</td>
			    				<td>입금액</td>
			    				<td>차액</td>
			    			</tr>

 <% 							
            if(vt_size > 0){
				for(int i=0; i<vt.size(); i++){ 
					
					Hashtable ht = (Hashtable)vt.elementAt(i);					
					
					if(AddUtil.parseInt(String.valueOf(ht.get("AMT5")))==0){
						ht.put("AMT5", String.valueOf(ht.get("AMT3")));						
					}
																	
					%>					    			
			    	
					    	<tr class=red bgcolor=#FFFFFF>
						            <td height=30><%=i+1%></td>
						            <td><%=ht.get("OUR_CAR_NO")%><br><%=ht.get("FIRM_NM")%></td>	
						             <td><%=ht.get("CAR_NO")%></td>	
						            <td><%=ht.get("FAULT_PER")%>%</td>						    	
				    			 <td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>		
				    			   <td align='right'><%=Util.parseDecimal(ht.get("AMT1"))%></td>    
				    			   <td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT")))%></td>
         							   <td align='right'><%=Util.parseDecimal(ht.get("AMT2"))%></td>
         							    <td align='right'><%=Util.parseDecimal(ht.get("AMT3"))%></td>
						 </tr>
		      <% 	}
	} %>		
			    		</table>
			    	</td>
			    </tr>
			    
			      <tr>
			    	<td height=25></td>
			    </tr>
			    <tr>
			    	<td colspan="2" style="font-weight:bold;">라. <span class=line>피고의 대차료 미지급</span></td>
			    </tr>
			    <tr>
			    	<td height=15></td>
			    </tr>
			    <tr>
			    	<td colspan="2">이에 원고는 피고에게 지급받지 못한 차액분을 받기 위하여 추가로 받아야할 금액에 대하여 지급할 것을 최고하였습니다(갑 제<%=vt_size+3%>호증 대차료 차액분 납부최고 참조).</td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">그러나 피고는 보험금 추가 지급을 거절하였는 바, 결국 원고는 이러한 차액분에 대한 지급을 전혀 받지 못하고 있는 상황입니다.</td>
			    </tr>
			    <tr>
			    	<td height=25></td>
			    </tr>
			    <tr> 
			      	<td style="font-weight:bold; font-size:14pt;" colspan="2">Ⅱ. <span class=line>원고의 피고에 대한 청구 원인</span></td>
			    </tr>
			    <tr>
			    	<td height=25></td>
			    </tr>
			    <tr> 
			      	<td style="font-weight:bold;" colspan="2">1. <span class=line>이 사건 사고들의 경우 발생한 피해자들의 손해의 내용 및 범위</span></td>
			    </tr>
			    <tr>
			    	<td height=15></td>
			    </tr>
			    <tr>
			    	<td colspan="2">피해자들은 이 사건 사고로 인하여 자신이 장기렌트한 차량들을 사용하지 못하게 됨으로 인하여 <span class=line>동종 또는 동급의 새로운 차량을 다시 단기간 동안(위 장기렌트 차량의 수리기간 동안) 렌트하여야 하므로 그 단기렌트비용 상당의 손해가 발생</span>하였다고 할 것입니다. 
			    	다시 말해서, 위 각 사고로 인한 피해자는 어디까지나 <span class=line>렌터카이용고객이지 렌터카 회사인 원고가 아니며,</span> 가해자 측인 피고가 배상하여야 할 손해의 범위 역시 <span class=line>렌터카이용고객이 위 사고로 인하여 렌트한 차량을 이용하지 못함으로써 다른 차량을 단기대여하기 위하여 지출하여야 하는 금액</span>입니다. 
			    	결국 피보험자(피고 보험사)가 피해자에게 배상해야 할 금액은 피해자들이 차량을 수리하는 기간 동안 다른 차량을 대여하는 과정에서 지출하여야 하는 단기렌트비용이 될 것이므로, 이는 가해자가 피해자에게 대차료에 상당하는 금액을 지급해야 함을 의미합니다.</td>
			    </tr>
			    <tr>
			    	<td height=25></td>
			    </tr>
			    <tr> 
			      	<td style="font-weight:bold;" colspan="2">2. <span class=line>피고 <span class=red><%=short_nm%></span>가 지급한 금액 산정의 근거</span></td>
			    </tr>
			    <tr>
			    	<td height=15></td>
			    </tr>
			    <tr>
			    	<td colspan="2">이에 원고는 급부의 편의상 피해자를 대신하여 피고 보험사에게 위 대차료에 상당하는 보험료를 청구하였는바, 피고 보험회사는 원고가 청구한 금액에 훨씬 미치지 못하는 금액만을 지급하였습니다.</td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">그런데 피고 보험회사가 지급한 금액이 원고가 청구한 금액과 차이가 나는 이유는, 원고가 대차료에 상당하는 금액을 청구하였는데 비하여 피고는 휴차료에 해당하는 손해금액만을 지급하였기 때문인 것으로 파악됩니다.</td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">그러나 피고 보험회사가 이처럼 원고에게 휴차료만을 지급하는 것은 부당한 바, 이에 대하여는 아래에서 항을 달리하여 자세히 설명하도록 하겠습니다.</td>
			    </tr>
			    <tr>
			    	<td height=25></td>
			    </tr>
			    <tr> 
			      	<td style="font-weight:bold;" colspan="2">3. <span class=line>피고의 보험료 지급금액 산정의 부당성</span></td>
			    </tr>
			    <tr>
			    	<td height=15></td>
			    </tr>
			    <tr> 
			      	<td style="font-weight:bold;" colspan="2">가. <span class=line>자동차보험약관상 대물배상의 지급기준으로서 휴차료와 대차료에대한 설명</span></td>
			    </tr>
			    <tr>
			    	<td height=15></td>
			    </tr>
			     <tr>
			    	<td colspan="2">보험회사는 사고발생시 보험약관에 따라 대물배상을 하게 되는데 그 성질은 <span class=line>피보험자의 손해배상채무를 인수하여 이를 배상</span>하는 것입니다.</td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">한편 대물배상의 보험금 지급기준에 대하여 휴차료와 대차료에 대한 구분이 있는데, “대차료”는 <span class=line>비사업용자동차</span>가 파손 또는 오손되어 가동하지 못하는 기간 동안에는 다른 자동차를 대신 사용할 필요가 있는 경우 
			    	그에 소요되는 필요 타당한 비용이라고 정의되고 있고, “휴차료”는 <span class=line>사업용자동차</span>가 파손 도는 오손되어 사용하지 못하는 기간 동안에 발생하는 타당한 영업손해라고 규정되어 있습니다. (갑 제 <span class=red><%=vt_size+4%>호증</span> 약관 참조)</td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">따라서 피고 보험회사들은 위 보험료를 지급함에 있어 <span class=line>이 사건 사고차량들의 소유가 원고라는 것을 이유로 하여</span> 이 사건 사고차량들을 영업용자동차로 보아 원고에게 휴차료만을 지급한 것으로 보입니다.</td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">그런데 위 대차료와 휴차료의 구분기준이 되는 것은 <span class=line>해당 차량이 비사업용자동차인지 아니면 사업용 자동차인지 여부인 것</span>으로 일응 보이는데, 이는 단순히 해당 차량의 등록 명의가 영업용 차량인지 아니면 비영업용 
			    	차량인지에 관한 형식적인 기준에 따라 일률적으로 구분되는 것이 아니라 <span class=line>통상적으로 해당 차량의 운행 목적에 따라 구별되는 개념</span>입니다. </td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">다시 말해서 사업용 자동차의 경우 <span class=line>해당 자동차의 운행 목적 자체가 영업에 공하여 지기 위하여 운행되는 것으로서 해당 차량의 운행 그 자체가 영업을 위한 경우를 의미[예를 들어 택시, 버스 등]</span>하는 데 비하여 비사업용 
			    	자동차의 경우 자동차의 운행 목적 자체가 영업에 공하여 지는 것이 아닌 것을 뜻합니다. 예를 들어 사업을 영위하는 일반 회사에서 영업을 위하여 사용하고자 구입한 법인 차량의 경우에도 이는 사업용 차량이 아닌 비사업용 차량에 해당하는바, 그 이유는 위 차량을 
			    	운행하는 목적 자체가 영업 그 자체로 되는 것은 아니기 때문입니다.</td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">따라서 위와 같이 휴차료와 대차료 간에 그 손해액의 산정이 차이가 나는 이유는 영업용 차량의 경우 해당 사고 차량의 운행 목적 자체가 영업에 공하여 지기 위한 것이기 때문에 <span class=line>피해자가 위 차량을 이용하지 못함으로써 발생하는 
			    	손해는 “영업손해”로서, 결국 위 영업손해가 “실손해”에 해당한다는 점</span>에 근거하는 것입니다. 그러나 사업용 차량이 아닌 비사업용 차량의 경우에는 해당 기간동안 위 차량을 이용하지 못함으로써 다른 차량을 이용하는데 소요되는 비용이 실손해가 되고, 이는 
			    	결국 대차료에 이르는 금액이 “실손해”에 해당하므로 보험회사는 이 경우 실손해를 배상하여야 하는 것입니다. </td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">그러므로 이 사건 사고에 따른 보험금 산정에 있어, 피고가 지급하여야 하는 보험금을 산정하기 위해서는 위 각 사고로 인한 피해자는 누구인지, 그 실손해의 범위는 어떠한지, 렌트된 차량을 영업용차량으로 보아야 하는지 비사업용차량으로 보아야 
			    	하는지가 이 사건의 주요 쟁점이 될 것입니다.</td>
			    </tr>
			    <tr>
			    	<td height=25></td>
			    </tr>
			    <tr> 
			      	<td style="font-weight:bold;" colspan="2">나. <span class=line>이 사건 사고의 피해자 및 손해의 내용과 그 배상 범위</span></td>
			    </tr>
			    <tr>
			    	<td height=15></td>
			    </tr>
			    <tr> 
			      	<td style="font-weight:bold;" colspan="2">(1) 문제점</td>
			    </tr>
			    <tr>
			    	<td height=15></td>
			    </tr>	
			    <tr>
			    	<td colspan="2">피고는 이 사건 사고차량의 소유가 렌트업을 영위하는 원고의 소유임에 착안하여, 위 사고차량에 대한 대물손해는 “휴차료”만을 지급하면 그것으로 족한 것으로 판단하고 있습니다. 그러나 피고는 실제 피해자와 손해의 범위를 오인하여 그 산정근거를 
			    	그르치고 있는 바, 앞서 지적한 바와 같이 위 사고로 인하여 원고가 피해자를 대신하여 피고에게 청구하고 있는 손해는 위 사고로 인하여 해당 차량을 이용하지 못함으로써 발생한 손해로서 그 피해자는 각 렌터카 이용고객이며, 위 렌터카 이용고객의 손해는 <span class=line>새로운 
			    	차량을 대차함으로써 발생하는 대차료에 상당하는 금액</span>임에도 피고는 이 사건 사고의 피해자가 마치 원고인 것처럼 오인하고 있습니다.</td>
			    </tr>
			    <tr>
			    	<td height=15></td>
			    </tr>
			    <tr>
			    	<td colspan="2">다시 말해서 피고의 보험료 산정 근거는, 이 사건 차량은 원고의 소유이므로 이 사건 사고로 인한 간접손해의 피해자 역시 렌터카 회사인 원고로 보아야 한다는 형식적인 논리에서 비롯된 것으로 보이나, <span class=line>이 사고로 인한 간접손해의 피해자는 실제 렌터카를 
			    	이용하고 있는 이용고객</span>으로 보아야 하므로 피고는 급부의 편의상 이용고객을 대신하여 보험금을 청구하는 원고에게 대차료 상당액의 보험료를 배상하여야 합니다.</td>
			    </tr>
			    <tr>
			    	<td height=15></td>
			    </tr>
			    <tr>
			    	<td colspan="2">이러한 주장을 뒷받침할 수 있는 근거에 대해서는 아래에서 항을 달리하여 검토하기로 하겠습니다.</td>
			    </tr>
			    <tr>
			    	<td height=25></td>
			    </tr>
			    <tr> 
			      	<td style="font-weight:bold;" colspan="2">(2) 장기렌탈의 특징</td>
			    </tr>
			    <tr>
			    	<td height=15></td>
			    </tr>
			    <tr>
			    	<td colspan="2">이 사안은, 렌터카 이용고객과 원고 간에 해당 차량에 대해서 장기 자동차대여계약이 체결된 경우임은 앞서 살펴본 바와 같습니다. 그런데 이 경우 렌터카 이용고객의 입장에서는 ① 해당 계약 기간 동안 당해 차량의 운행이익 및 지배권을 포괄적으로 부여 받게 되고,
			    	 ② 원고의 입장에서는 해당 사고여부에도 불문하고 <span class=line>해당 차량에 대하여 매월 렌트비를 정기적으로 납부</span> 받게 되므로, 원고 입장에서는 해당 차량에 대해서 별도의 “휴차손해”라는 것이 발생할 수 없습니다. 다시 말해 렌터카 회사인 원고가 이용고객으로부터 
			    	 매월 지급받고 있는 렌트비는 이미 고객에게 제공한 해당 차량에 대한 고정비용이기 때문입니다.</td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">나아가 이 사안과 같이 이용고객과 렌터카 회사 간에 장기렌트계약이 체결된 경우에는 <span class=line>이 계약체결기간 동안의 사고 차량에 대한 모든 실질적인 지배권한은 렌터카 이용고객이 보유</span>하고 있으며, 렌터카 이용고객은 <span class=line>해당 차량을 자신의 자가용으로 사용</span>하게 됩니다. 
			    	따라서 장기렌트의 경우 이용고객은 해당 계약기간 동안 이를 자신의 지배하에 비사업용차량의 용도로 사용하는 것이므로 위 차량을 계약기간 동안 마치 자신의 자가용으로 사용하고 있는 고객의 입장에서는 해당 대여차량을 사업용 자동차라고 볼 수 없습니다.</td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">따라서 이러한 상황에서 차량을 장기렌트한 이 사건 이용고객들이 해당 차량에 대하여 사고를 당한 경우, 렌터카 이용고객이 해당 차량을 일시적으로 사용하지 못하고 새로운 차량을 대차하기 위하여 별도의 비용을 감수하여야 함으로써 발생하는 손해는
			    	 “렌터카 이용고객”에게 발생한 손해이지 렌터카 회사에게 발생한 손해라고 볼 수 없습니다.</td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">다시 말해서 해당 차량이 <span class=line>“사업용 자동차”인지 여부</span>는 <span class=line>고객과 렌터카 회사와의 관계에서만 문제</span>될 수 있을 뿐, 이 사건 각 사고와 같이 이 사건 이용고객이 자동차장기대여계약을 통하여 장기대여받은 자동차를 <span class=line>비사업용의 목적으로 운행하는 과정에서 
			    	발생한 사고의 경우</span> 궁극적으로는 일시적으로 새로운 차를 대차하여야 하는 간접손해의 피해자는 이 사건 이용 고객인 이상, 이미 고객에게 대여되어 고객이 이용하고 있는 해당 차량은 “이용고객과 가해자와의 관계”에서는 비사업용 자동차에 불과한 것이므로, 피고는 
			    	이용고객이 새로운 차를 대차하여야 함으로써 드는 비용인 대차료 상당액을 보상하여야 하는 것입니다[다만 급부의 편의상 렌터카 회사가 이를 청구하는 것에 불과합니다].</td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">뿐만 아니라 보험금 지급기준에 있어서 휴차료에 상응하는 손해를 배상하도록 되어 있는 “영업용 차량인지 여부”에 대한 기준은 자동차 등록증 상의 구분기준에 따라 일의적으로 적용된다고 볼 수 없는 바, 이에 관한 법령상 명확한 기준이 전혀 마련되어 있지 않습니다. 또한 영업용 차량의 경우 휴차료에 상당하는 
			    	손해를 배상하도록 한 이유는 해당 간접 손해는 “영업손해”에 불과하기 때문이나, 앞서 지적한 바와 같이 장기대여의 경우 위 간접손해를 입은 피해자는 어디까지나 렌터카이용고객으로서 “영업손해”가 아닌 “대차손해”가 그 실손해이므로 해당 차량이 자동차 등록증 상에 사업용 차량으로 구분되어 있다는 이유만으로 어느 경우에라도 
			    	반드시 해당 차량에 대해서는 휴차손해만 지급받아야 한다고 일의적으로 단정할 수도 없기 때문입니다.</td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">따라서 사고가 발생한 경우 렌터카 이용고객은 렌트기간 중 해당 사고로 인하여 기존에 렌트한 차량을 이용하지 못하게 되어 별도의 비용을 들여 새로운 차를 대차하여야 하는 것이므로 간접손해에 대한 피해자는 사고를 당한 이 사건 렌트카 이용고객으로 보아야 한다는 결론으로 귀결될 수 있습니다. 
			    	그러므로 이에 따라 가해자 또는 가해자의 보험회사는 이용고객이 이로 인하여 새로운 차량을 대차 하는데 소요되는 비용인 대차료 상당액을 지급하여야 하므로, 이를 이용고객을 대신하여 원고가 피고에게 청구하는 이상, 피고는 이를 전액 지급할 의무가 있는 것입니다.</td>
			    </tr>
			    <tr>
			    	<td height=25></td>
			    </tr>
			    <tr> 
			      	<td style="font-weight:bold;" colspan="2">(3) 세금계산서의 발행 측면</td>
			    </tr>
			    <tr>
			    	<td height=15></td>
			    </tr>
			    <tr>
			    	<td colspan="2">나아가 자동차장기대여의 경우 원고를 비롯한 렌터카 회사가 이용고객에게 새로운 차를 대차하는 경우에 있어서 렌터카 회사는 <span class=line>단기 렌트비용인 대차료를 적용하여 고객명의로 세금계산서를 발행</span>하고 있습니다. 이를 보더라도 간접손해의 피해자는 실질적으로 렌터카 이용고객이라는 점이 명확하게 증명됩니다.</td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">다시 말해서 이용고객은 원칙적으로 단기렌트에 상응하는 대차이용료를 렌터카 회사에게 지급하여야 하고 사후에 이를 가해자 측 보험회사로부터 전보 받을 수 있는 것이 원칙이나, 이를 <span class=line>급부의 편의상 렌터카회사인 원고가 보험회사인 피고에게 직접 그 지급을 청구하는 것에 불과합니다.</span></td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">특히 앞서 지적한 바와 같이, 이 사건 각 장기대여계약서에서는 렌터카이용고객이 상대방 과실로 인하여 발생한 사고로 인하여, 해당 차량을 이용하지 못하는 경우 이는 상대방인 가해자 측이 배상할 책임이 있는 것이 원칙이므로 원고는 다른 차량을 무상으로 대차하는 서비스를 제공하지 않고 있습니다. 
			    	따라서 이 경우 피해자인 렌터카 이용고객이 원고로부터 대차를 받기 위해서는 이를 유상으로 단기대여를 별도로 하여야 하는바, 이에 원고는 이 사건 렌터카이용고객에게 세금계산서를 발행하였던 것입니다(원칙적으로 이 사건 렌터카이용고객은 가해자 측에 위 단기대여에 상당하는 금액까지 간접손해로서 청구할 수 
			    	있으므로 위 비용을 원고가 피고에게 곧바로 지급 청구한 것임은 앞서 설명드린 바와 같습니다).</td>
			    </tr>
			    <tr>
			    	<td height=25></td>
			    </tr>
			    <tr> 
			      	<td style="font-weight:bold;" colspan="2">(4) 다른 렌터카 회사로부터 고객이 대차한 경우와의 비교 측면</td>
			    </tr>
			    <tr>
			    	<td height=15></td>
			    </tr>
			    <tr>
			    	<td colspan="2">또한 현재 관행상, 피고는 만일 <span class=line>렌터카 이용 고객이 기존에 장기렌트계약을 체결하였던 업체인 원고가 아닌 다른 렌터카회사로부터 새로운 차를 대차한 경우, 다른 렌터카회사에게는 “대차료 상당액”을 지급</span>하고 있습니다[물론 이러한 경우에도 다른 렌터카 회사는 이용고객의 명의로 세금계산서를 발행하되, 
			    	급부의 편의상 자신들이 직접 보험사에 이를 청구하고 있습니다].</td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">이를 보더라도, 장기렌트 계약을 체결한 이용고객이 사고를 당한 경우 해당 이용차량을 일시적으로 사용하지 못함으로써 새로운 차량을 일시적으로 사용함에 따라 발생하게 되는 피해의 주체는 “렌터카 이용고객”이라는 점이 명확히 증명될 수 있으며, 그 손해의 범위는 대차료 상당액이라는 사실 역시 더불어 증명됩니다.</td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">뿐만 아니라 이 경우 렌터카 이용고객이 장기렌트계약을 체결한 업체가 아닌 다른 렌터카 업체로부터 새로운 차를 일시적으로 대차하였다는 점만 달라질 뿐, 모든 조건은 동일한 상황[여전히 기존 렌터카 회사와의 기존계약관계가 유지되고 있는 이상 고객은 차를 이용하지 못하더라도 월 대여료를 기존 계약관계가 있는 
			    	렌터카 업체에게 계속 지급하여야 하기 때문에 다른 조건은 동일함]에서 <span class=line>이용 고객이 기존 대차한 차량의 수리시까지 어떠한 렌터카 업체로부터 새로운 차를 일시적으로 대차할 것인지에 대한 우연한 사정에 따라 그 보상범위가 달라진다는 것인데</span> 이러한 구별은 불합리할 뿐만 아니라 이를 달리 구별하여야 할 합리적인 이유가 없습니다.</td>
			    </tr>
			    
			        <tr>
			    	<td height=25></td>
			    </tr>
			    <tr> 
			      	<td style="font-weight:bold;" colspan="2">다. <span class=line>소결</span></td>
			    </tr>
			    <tr>
			    	<td height=15></td>
			    </tr>
			    <tr>
			    	<td colspan="2">따라서 <b>①</b>다른 렌터카업체는 당해 사고로 간접손해 등이 발생할 여지가 없음에도 보험사로부터 대차료 상당액을 지급받을 수 있는 점에 비추어볼 때 장기렌터카 이용고객이 새로운 차를 대차하여야 함으로서 발생되는 별도의 간접손해는 <span class=line>이용 고객에게 발생되는 것</span>이므로 <span class=line>실질적인 피해자는 렌터카 이용고객</span>이고, 이를 렌터카 업체가 급부의 편의상 
			    	직접 청구하는 것에 불과하다는 점, <b>②</b>만일 이용고객이 다른 렌터카회사로부터 일시적으로 신차를 대차하는 상황을 가정하더라도, <span class=line>렌터카 이용고객으로서는 월대여료를 원고 회사에게 여전히 지급하여야 한다</span>는 점에 비추어볼 때 렌터카이용고객이 지급하는 <span class=line>월 대여료(휴차료 상당액에 불과)는 기존에 대여한 차량에 대한 고정적인 급부에 불과</span>하다는 점, 
			    	<b>③</b>이용고객이 다른 렌터카 업체로부터 대차하는 경우 다른 렌터카 업체 역시 <span class=line>고객 명의로 세금계산서를 발행</span>하고 이를 다른 렌터카업체가 보험회사에 직접 청구한다는 점, <b>④</b>이 경우 조합으로부터 지급되는 금액은 대차료 상당액이므로, <span class=line>장기렌트의 경우 새로운 차를 대차함으로써 발생하는 손해의 범위는 대차료 상당의 손해액이라는 점</span>이 간접적으로 확인가능하다는 
			    	점 등에 비추어 보더라도 이 사건의 경우 <span class=line>실질적인 피해자는 렌터카 이용고객</span>이기 때문에 보험계약자인 가해자의 과실로 사고가 발생하여 렌터카 이용고객이 새로운 차를 대차하는 경우 피고가 원고회사에게 휴차료 상당액만 지급하는 것은 부당하다고 할 것입니다. </td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">이하에서는 각 차량별로 원고에게 지급해야 할 구체적인 보험금의 금액에 대하여 설명하겠습니다.</td>
			    </tr>
			    
			        <tr>
			    	<td height=50></td>
			    </tr>
			    <tr> 
			      	<td style="font-weight:bold; font-size:14pt;" colspan="2">Ⅲ. <span class=line>원고의 피고 보험회사에 대한 각 보험금 청구금액의 구체적인 산정내역</span></td>
			    </tr>
			    <tr>
			    	<td height=25></td>
			    </tr>
			    
 		 <% 							
            if(vt_size > 0){
				for(int i=0; i<vt.size(); i++){ 
					
					Hashtable ht = (Hashtable)vt.elementAt(i);					
					
					if(AddUtil.parseInt(String.valueOf(ht.get("AMT5")))==0){
						ht.put("AMT5", String.valueOf(ht.get("AMT3")));						
					}
					
					String i_start_dt = String.valueOf(ht.get("USE_ST"));				   
					String i_end_dt = String.valueOf(ht.get("USE_ET"));
			   
			%>						    
			    
			    <tr> 
			      	<td style="font-weight:bold;" colspan="2"><%=i+1%>. <span class=line>피해자 <span class=red><%=ht.get("FIRM_NM")%> (<%=ht.get("OUR_CAR_NO")%>)</span> 관련 보험금청구금액</span></td>
			    </tr>
			    <tr>
			    	<td height=15></td>
			    </tr>
			    <tr> 
			      	<td colspan="2">피고의 보험가입자인 성명불상의 가해자는 <%=AddUtil.ChangeDate2(String.valueOf(ht.get("ACCID_DT")))%> 피해자 <%=ht.get("FIRM_NM")%>가 운전하는 <%=ht.get("OUR_CAR_NO")%>&nbsp; <%=ht.get("CAR_NM")%>&nbsp;<%=ht.get("CAR_NAME")%> 차량을 충돌하여 파손함으로써 피해자 <%=ht.get("FIRM_NM")%> 은 위 차량의 수리기간인 <%=AddUtil.ChangeDate2(i_start_dt)%>부터 <%=AddUtil.ChangeDate2(i_end_dt)%></span> 
			      	<%=ht.get("USE_DAY")%>일&nbsp;<%=ht.get("USE_HOUR")%>시간 동안 동급차량인 <%=ht.get("CAR_NO")%> 차량을 대차해야 하는 손해가 발생하였고 이에 위 피해자 <%=ht.get("FIRM_NM")%>는 원고로부터 위 차량을 1일당 <%=Util.parseDecimal(ht.get("DAY_AMT"))%>원(부가세포함) 합계 <%=Util.parseDecimal(ht.get("AMT1"))%>원((<%=Util.parseDecimal(ht.get("DAY_AMT"))%>원(일)*<%=ht.get("USE_DAY")%>일)+(<%=Util.parseDecimal(ht.get("DAY_AMT"))%>원(일)/24*<%=ht.get("USE_HOUR")%>시간))에 대여 받아 사용하였습니다. 이에 원고는 <%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%> 피고 보험회사에게 <%=Util.parseDecimal(ht.get("AMT1"))%>원을 청구하였으나 
			      	피고는 원고에게 <% if(AddUtil.parseInt(String.valueOf(ht.get("AMT2")))==0){%>입금을 하지 않고 있습니다.<%} else {%><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT")))%>경 단지<%=Util.parseDecimal(ht.get("AMT2"))%>원만을 지급하였습니다.<%} %>(갑 제<%=i+1%>호증의 자동차대여이용계약서, 사고대차서비스계약서, 거래명세서, 세금계산서 내지 갑 제<%  if    ( AddUtil.parseInt( String.valueOf(ht.get("ACCID_DT")).substring(0,8))   > 20110930  ) { %><%=vt.size()+2%><%} else {%><%=vt.size()+1%><% } %>호증 아마존카 단기대여 요금표 참조).</td>   			    
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">따라서 원고는 피해자 <%=ht.get("FIRM_NM")%>에게 <% if(AddUtil.parseInt(String.valueOf(ht.get("AMT2")))==0){%> 대차료 <%=Util.parseDecimal(ht.get("AMT3"))%>원<% }  else {%> 대차료와 휴차료의 차액인 <%=Util.parseDecimal(ht.get("AMT3"))%>원(<%=Util.parseDecimal(ht.get("AMT1"))%>원-<%=Util.parseDecimal(ht.get("AMT2"))%>원)<%}%>을 지급받을 채권을 여전히 가지고 있고, 피해자 <%=ht.get("FIRM_NM")%>는 가해자의 보험자인  피고에게 같은 금액의 보험금청구권을 가지고 있기 때문에 원고는 피해자 <%=ht.get("FIRM_NM")%>를 
			    	대위하여 위 보험금청구권을 행사하였으므로 피고는 원고에게 <%=Util.parseDecimal(ht.get("AMT3"))%>원 및 원고의 청구일 다음날인 <span class=red1><%=AddUtil.ChangeDate2( c_db.addDay(String.valueOf(ht.get("RENT_START_DT")) , 1)  ) %></span>부터 이 사건 소장부본 송달일까지는 민법에 의한 연 5%의, 그 다음날부터 다 갚는 날까지는<% if ( i < 1  )  {%> 소송촉진 등에 관한 특례법(이하 “<b>소송촉진등특례법</b>”)<%}else {%> 소송촉진등특례법<%} %>에 의한 연 20%의 각 율에 의한 지연손해금을 배상해야할 의무가 있습니다.</td>
			    </tr>
			    <tr>
			    	<td height=25></td>
			    </tr>
			    
	      <% 	}
	} %>					    
			
			    <tr> 
			      	<td style="font-weight:bold; font-size:14pt;" colspan="2">Ⅳ. <span class=line>결 론</span></td>
			    </tr>
			    <tr>
			    	<td height=25></td>
			    </tr>
			    <tr>
			    	<td colspan="2">이 사건 사고와 같은 경우 사고로 인한 피해자인 이 사건 렌트이용고객의 손해액은 대차료 상당액이라 할 것이고 이에 대한 보험금 청구권을 원고가 대위 행사하는 것이므로 피고는 원고에게 대차료 상당의 금액과 지급한 금액과의 차액을 지급해야 할 것입니다.</td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">위와 같은 사정을 모두 참작하시어 피해자들이 실질적인 손해를 보상받을 수 있도록, 또한 우연한 사정에 의하여 피고가 부당한 이득을 얻고 원고에게 손해를 전가시키는 일이 없도록, 원고 청구를 모두 인용하여 주시기 바랍니다.</td>
			    </tr>
			    <tr>
			    	<td height=50></td>
			    </tr>
			    <tr>
			    	<td colspan="2">당사는 이와 유사한 사건으로 서울중앙지방법원 2011나10012 판결을 통해 일부승소하였습니다.</td>
			    </tr>
			</table>
		</td>
	</tr>
</table>

<p style='page-break-before:always'><br style="height:0; line-height:0"></P>
<table width='650' border="0" cellpadding="0" cellspacing="0" align=center>
    <tr> 
      	<td height="20"></td>
    </tr>
    <tr>
    	<td align=center style="font-size : 17pt; font-weight:bold;">-------&nbsp; 입&nbsp;&nbsp;&nbsp; 증&nbsp;&nbsp;&nbsp; 방&nbsp;&nbsp;&nbsp; 법 &nbsp;-------</td>
    </tr>
    <tr> 
      	<td height="50"></td>
    </tr>
    <tr>
    	<td align=center>
    		<table width="95%" border="0" cellspacing="0" cellpadding="0" class="two">
    		
    		 <% 							
            if(vt_size > 0){
				for(int i=0; i<vt.size(); i++){ 
					
					Hashtable ht = (Hashtable)vt.elementAt(i);					
					
					if(AddUtil.parseInt(String.valueOf(ht.get("AMT5")))==0){
						ht.put("AMT5", String.valueOf(ht.get("AMT3")));						
					}
																	
					%>					    			
					    	<tr>
					    	<td>1. 갑 제<%=i+1%>호증  &nbsp;&nbsp;<<%=ht.get("FIRM_NM")%>>의<br> 
					           <%=i+1%>-1호증 자동차대여이용계약서, <%=i+1%>-2호증 사고대차서비스계약서, <%=i+1%>-3호증 거래명세서, <%=i+1%>-4호증 세금계산서.
							</td>
						</tr>
											 
		      <% 	}
	} %>		
	           		
           		<tr>
					<td>1. 갑 제<%=vt.size()+1%>호증  &nbsp;&nbsp;아마존카 단기대여요금표 [2009년 01월 15일] 기준</td>
           		</tr>
           		<tr>
					<td>1. 갑 제<%=vt.size()+2%>호증   &nbsp;&nbsp;개정된 아마존카 단기대여요금표 [2011년 10월 01일] 기준</td>
           		</tr>
           		<tr>
					<td>1. 갑  제<%=vt.size()+3%>호증   &nbsp;&nbsp;대차료 차액분 납부최고</td>
           		</tr>
           		<tr>
					<td>1. 갑  제<%=vt.size()+4%>호증   &nbsp;&nbsp;약관</td>
           		</tr>
			</table>
		</td>
	</tr>
</table>


<p style='page-break-before:always'><br style="height:0; line-height:0"></P>
<table width='650' border="0" cellpadding="0" cellspacing="0" align=center>
    <tr> 
      	<td height="20"></td>
    </tr>
    <tr>
    	<td align=center style="font-size : 17pt; font-weight:bold;">-------&nbsp; 입&nbsp;&nbsp;&nbsp; 증&nbsp;&nbsp;&nbsp; 방&nbsp;&nbsp;&nbsp; 법 &nbsp;-------</td>
    </tr>
    <tr> 
      	<td height="50"></td>
    </tr>
    <tr>
    	<td align=center>
    		<table width=100% border=0 cellspacing=1 cellpadding=0  bgcolor=#000000 class="one">
				<tr>
					<td width="15%"  bgcolor=#FFFFFF>서증번호</td>
					<td width="35%"  bgcolor=#FFFFFF>서증명</td>
					<td width="50%"  bgcolor=#FFFFFF>입증취지</td>
				</tr>
    		 <% 							
            if(vt_size > 0){
				for(int i=0; i<vt.size(); i++){ 
					
					Hashtable ht = (Hashtable)vt.elementAt(i);					
					
					if(AddUtil.parseInt(String.valueOf(ht.get("AMT5")))==0){
						ht.put("AMT5", String.valueOf(ht.get("AMT3")));						
					}
																	
					%>					    			
			<tr>
				<td  bgcolor=#FFFFFF style="font-size : 10pt;" align="center">갑<%=i+1%>-1호증</td>
				<td  bgcolor=#FFFFFF style="font-size : 10pt;">&nbsp;자동차대여이용계약서 앞,뒤</td>
				<td  bgcolor=#FFFFFF style="font-size : 10pt;">&nbsp;장기렌트 계약 사실을 입증하기 위한 것임.</td>
			</tr>
			<tr>
				<td  bgcolor=#FFFFFF style="font-size : 10pt;" align="center">갑<%=i+1%>-2호증</td>
				<td  bgcolor=#FFFFFF style="font-size : 10pt;">&nbsp;사고대차서비스계약서</td>
				<td  bgcolor=#FFFFFF style="font-size : 10pt;">&nbsp;사고대차 서비스가 제공되었음을 입증하기 위한 것임.</td>
			</tr>
			<tr>
				<td  bgcolor=#FFFFFF style="font-size : 10pt;" align="center">갑<%=i+1%>-3호증</td>
				<td  bgcolor=#FFFFFF style="font-size : 10pt;">&nbsp;거래명세서</td>
				<td  bgcolor=#FFFFFF style="font-size : 10pt;">&nbsp;구체적인 손해 산정을 위한 것임.</td>
			</tr>			
			<tr>
				<td  bgcolor=#FFFFFF style="font-size : 10pt;" align="center">갑<%=i+1%>-4호증</td>
				<td  bgcolor=#FFFFFF style="font-size : 10pt;">&nbsp;세금계산서</td>
				<td  bgcolor=#FFFFFF style="font-size : 10pt;">&nbsp;구체적인 손해 산정을 위한 것임.</td>
			</tr>
		      <% 	}
	} %>		
	           		
			</table>
		</td>
	</tr>
</table>
<p style='page-break-before:always'><br style="height:0; line-height:0"></P>
<table width=650 border=0 cellspacing=0 cellpadding=0 align=center>
	<tr> 
      	<td height="50"></td>
    </tr>
	<tr>
    	<td align=center style="font-size : 17pt; font-weight:bold;">-------&nbsp; 첨&nbsp;&nbsp;&nbsp; 부&nbsp;&nbsp;&nbsp; 서&nbsp;&nbsp;&nbsp; 류 &nbsp;-------</td>
    </tr>
    <tr> 
      	<td height="70"></td>
    </tr>
    <tr>
    	<td align=center>
    		<table width="70%" border="0" cellspacing="0" cellpadding="0" class="two">
    			<tr>
    				<td>1. 위 입증방법</td>
    				<td align=right>각 2통</td>
    			</tr>
    			<tr>
    				<td>1. 법인등기부등본</td>
    				<td align=right>각 1통</td>
    			</tr>
    			<tr>
    				<td>1. 납부서</td>
    				<td align=right>1통</td>
    			</tr>
    			<tr>
    				<td>1. 소장부본</td>
    				<td align=right>1통</td>
    			</tr>
    		</table>
    	</td>
    </tr>
    <tr>
    	<td height=150></td>
    </tr>
    <tr>
    	<td align=center style="font-size : 15pt; font-weight:bold;"><%=AddUtil.getDate(1)%>.&nbsp;&nbsp;<%=AddUtil.getDate(2)%>.&nbsp;&nbsp;&nbsp;&nbsp;.</td>
    </tr>
    <tr>
    	<td height=100></td>
    </tr>
    <tr>
    	<td align=right style="font-size : 19pt; font-weight:bold;">주식회사 아마존카</td>
    </tr>
    <tr>
    	<td height=40></td>
    </tr>
    <tr>
    	<td align=right style="font-size : 19pt; font-weight:bold;">대표이사 조성희</td>
    </tr>
     <tr>
    	<td height=150></td>
    </tr>
    <tr align="center"> 
      	<td height="40" style="font-size : 20pt;"><b>서 울 남 부 지 방 법 원 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 귀  중</b></td>
    </tr>    
</table>
</form>
</body>
</html>
