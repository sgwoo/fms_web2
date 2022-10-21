<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.forfeit_mng.*, acar.user_mng.*, acar.estimate_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineGovBn" 	scope="page" class="acar.forfeit_mng.FineGovBean"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String doc_id 		= request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String doc_dt 		= "";
	int start_num 		= request.getParameter("start_num")==null?0:Integer.parseInt(request.getParameter("start_num"));
	int end_num 		= request.getParameter("end_num")==null?0:Integer.parseInt(request.getParameter("end_num"));
	
	CommonDataBase c_db  = CommonDataBase.getInstance();
	UserMngDatabase u_db = UserMngDatabase.getInstance();		
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	EstiDatabase e_db	 = EstiDatabase.getInstance();
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	FineGovBn = FineDocDb.getFineGov(FineDocBn.getGov_id());
	
	doc_dt = FineDocBn.getDoc_dt();
	
	//과태료리스트
	Vector FineList = FineDocDb.getFineDocLists(doc_id);
	
	if(FineDocBn.getH_mng_id().equals(""))		FineDocBn.setH_mng_id("000026");
	
	//담당자정보
	UsersBean h_user = u_db.getUsersBean(FineDocBn.getH_mng_id());
	UsersBean b_user = u_db.getUsersBean(nm_db.getWorkAuthUser("과태료담당자"));
	
	Hashtable br1 = c_db.getBranch(b_user.getBr_id());
		
	//인쇄여부 수정
	if(FineDocBn.getPrint_dt().equals("")){
		FineDocDb.changePrint_dt(doc_id, user_id);
	}

	//변수
	String var3 = e_db.getEstiSikVarCase("1", "", "fine_app1");//첨부서류1
	String var4 = e_db.getEstiSikVarCase("1", "", "fine_app2");//첨부서류2
	String var5 = e_db.getEstiSikVarCase("1", "", "fine_app3");//첨부서류3
	String var6 = e_db.getEstiSikVarCase("1", "", "fine_app4");//첨부서류4
		
	int app_doc_h = 0;
	String app_doc_v = "";
	if(FineDocBn.getApp_doc1().equals("Y")){	
		app_doc_h += 20;
		app_doc_v += "1";
	}
	if(FineDocBn.getApp_doc2().equals("Y")){
		app_doc_h += 20;
		app_doc_v += "2";
	}
	/* if(FineDocBn.getApp_doc3().equals("Y")){
		app_doc_h += 20;
		app_doc_v += "3";
	} */
	if(FineDocBn.getApp_doc4().equals("Y")){
		if(!FineDocBn.getGov_st().equals("경찰서")){	//경찰서는 제외(20190910)
			app_doc_h += 20;
			app_doc_v += "4";
		}
	}
	int app_doc_size = app_doc_h/20;	
				
	//내용 라인수
	int tot_size = FineList.size();
	
	//한라인당 길이
	int line_h = 32;//20120104 위반일자에서 일시로 바뀜 32->48
	
	//페이지 길이	
	int page_h = 850;
	
	//각 테이블 기본 길이
	int table1_h = 465+60;
	int table2_h = tot_size*line_h;	
	int table3_h = app_doc_h+140;
	
	//출력페이지수 구하기
	int page_cnt = ((table1_h+table2_h+table3_h)/page_h);
	if((table1_h+table2_h+table3_h)%page_h != 0) page_cnt = page_cnt + 1;
	
	//마지막 테이블 길이 구하기
	int height = (page_h*page_cnt)-(table1_h+table2_h);	
	
	String chk = "1";
	if(FineList.size()>0){
		for(int i=0; i<FineList.size(); i++){ 
			FineDocListBn = (FineDocListBean)FineList.elementAt(i);
			if(FineDocListBn.getCar_no().indexOf("허") != -1) chk = "0";
		}
	}
	String exp = "N";
	if(chk.equals("1") && FineGovBn.getGov_nm().equals("안산시 단원구청장")){
		exp = "Y";
	}
	
	double img_width 	= 690;
	double img_height 	= 1019;
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>
</head>
<body leftmargin="15" topmargin="1" onLoad="javascript:onprint()" >
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>
<form action="" name="form1" method="POST" >
  <table width='670' height="<%=table1_h%>" border="0" cellpadding="0" cellspacing="0">
    <tr> 
      <td colspan="2" height="40" align="center" style="font-size : 18pt;"><b><font face="바탕">Pick 
        amazoncar! We'll pick you up.</font></b></td>
    </tr>
    <tr> 
      <td colspan="2" height="5" align="center"></td>
    </tr>
    <tr bgcolor="#000000"> 
      <td colspan="2" align='center' height="10"> <table width="100%" border="0" cellspacing="1" cellpadding="0">
          <tr bgcolor="#FFFFFF"> 
            <td height="40"> <table width="100%" border="0" cellspacing="0" cellpadding="5">
                <tr> 
                  <td height="20" colspan="2" style="font-size : 9pt;"><font face="바탕"><%=br1.get("BR_POST")%>
                    <%=br1.get("BR_ADDR")%></font></td>
                  <td height="20" style="font-size : 9pt;" ><font face="바탕">Tel:02-392-4242(대표번호)</font></td>
                </tr>
                <tr>
                	<td height="20" style="font-size : 9pt;"><font face="바탕"><%=h_user.getDept_nm()%>장 
                    <%=h_user.getUser_nm()%></font></td>
                  	<td height="20" style="font-size : 9pt;"><font face="바탕">담당자 
                    <%=b_user.getUser_nm()%>(<%=b_user.getUser_email()%>)</font></td>
                	<td colspan="2" height="20" style="font-size : 9pt;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font face="바탕"><%=b_user.getHot_tel()%>(직통번호)</font></td>
                </tr>
                <tr>
                  <td height="20" colspan="2" style="font-size : 9pt;"><font face="바탕">http://www.amazoncar.co.kr</font></td>
                  <td height="20" style="font-size : 9pt;" ><font face="바탕">Fax:<%if(b_user.getDept_id().equals("0002")){%>02-3775-4243<%}else{%><%=br1.get("FAX")%><%}%></font></td>
                </tr>
              </table></td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td height="20" colspan="2" align='center'></td>
    </tr>
    <tr> 
      <td height="125" colspan="2" align='center'> <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td width="10%" height="25" style="font-size : 10pt;"><font face="바탕">문서번호</font></td>
            <td width="3%" height="25" style="font-size : 10pt;"><font face="바탕">:</font></td>
            <td height="25" width="87%" style="font-size : 10pt;"><font face="바탕"><%=FineDocBn.getDoc_id()%> 
              </font></td>
          </tr>
          <tr> 
            <td height="25" style="font-size : 10pt;"><font face="바탕">시행일자</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕">:</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕"><%=AddUtil.getDate3(FineDocBn.getDoc_dt())%></font></td>
          </tr>
          <tr> 
            <td height="25" style="font-size : 10pt;"><font face="바탕">수&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 신</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕">:</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕"><%=FineGovBn.getGov_nm()%></font></td>
          </tr>
          <tr> 
            <td height="25" style="font-size : 10pt;"><font face="바탕">참&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 조</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕">:</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕"><%=FineDocBn.getMng_dept()%> 
              <%if(!FineDocBn.getMng_nm().equals("")){%>
              &nbsp; ( <%=FineDocBn.getMng_pos()%> <%=FineDocBn.getMng_nm()%> 
              ) 
              <%}%>
              </font></td>
          </tr>
          <tr> 
            <td height="25" style="font-size : 10pt;"><font face="바탕">제&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 목</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕">:</font></td>
            <td height="25" style="font-size : 10pt;"><font face="바탕">장애인전용주차구역위반 과태료 부과 처분에 대한 
			  <%if(exp.equals("Y")){%>
			  이의 제기 (비송사건절차법에 따른 처리 요청)
			  <%}else{%>
			  의견 제출 (과태료 납부의무자 변경 요청)
			  <%}%>
			  </font></td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td height="20" colspan="2" align='center'></td>
    </tr>
    <tr bgcolor="#999999"> 
      <td colspan=2 align='center' height="3" bgcolor="#333333"></td>
    </tr>
    <tr> 
      <td height="20" colspan=2 align='center'>&nbsp;</td>
    </tr>
    <tr> 
      <td align='center' height="30" width="0" style="font-size : 10pt;"><font face="바탕">&nbsp;</font></td>
      <td width="*" height="30" style="font-size : 10pt;"><font face="바탕">1. 귀 <%=FineDocBn.getGov_st()%>의 
        무궁한 발전을 기원합니다.</font></td>
    </tr>
	<tr> 
      <td align='center' height="30" style="font-size : 10pt;"><font face="바탕">&nbsp;</font></td>
      <td height="30" style="font-size : 10pt;"><font face="바탕">2. 당사에 부과(부과예정)한 장애인전용주차구역위반 과태료 처분에 대하여 아래와 같이 
        </font></td>
    </tr>
    <tr> 
      <td height="30" colspan="2" style="font-size : 10pt;"><font face="바탕"> &nbsp;&nbsp;&nbsp;&nbsp;의견을 진술하오니 (질서 위반 행위 규제법 제20조) 
        </font></td>
    </tr>
    <tr> 
    	<td align='center' height="30" style="font-size : 10pt;"><font face="바탕">&nbsp;</font></td>
      <td height="30" colspan="2" style="font-size : 10pt;"><font face="바탕"> 
	    <%if(exp.equals("Y")){%>
	    3. 질서위반행위규제법 제21조 1항 및 제28조에 근거하여 관할법원에 이 사실을 통보하여 정당한 처분을 받도록
		<%}else{%>
		3. 납부의무자를 당사에서 임차인으로 변경 처분하여 주시거나, 질서 위반 행위 규제법 제21조 
		<%}%>
        </font></td>
    </tr>
    <tr> 
      <td height="30" colspan="2" style="font-size : 10pt;"><font face="바탕"> 
	    <%if(exp.equals("Y")){%>
	   &nbsp;&nbsp;&nbsp;&nbsp; 처리하여 주십시오.
		<%}else{%>
		&nbsp;&nbsp;&nbsp;&nbsp;1항 및 제28조에 근거하여 관할법원에 이 사실을 통보하여 정당한 처분을 받도록 처리하여 주십시오.
		<%}%>
        </font></td>
    </tr>
    <tr> 
      <td colspan=2 align='center' height="50" style="font-size : 9pt;"><font size="2" face="바탕">== 아&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;래 
        ==</font></td>
    </tr>
    <tr bgcolor="#000000"> 
      <td colspan="2" align='center' height="10"> <table width="100%" border="0" cellspacing="1" cellpadding="0">
          <tr bgcolor="#A6FFFF" align="center"> 
            <td style="font-size : 8pt;" rowspan="2" width="4%"><font face="바탕">연번</font></td>
            <td style="font-size : 10pt;" rowspan="2" width="14%"><font face="바탕">위반일시</font></td>
            <td style="font-size : 10pt;" rowspan="2" width="11%"><font face="바탕">차량번호</font></td>
            <td style="font-size : 10pt;" colspan="4" height="25"><font face="바탕">임차인</font></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td style="font-size : 8pt;" width="15%" height="25" align="center" bgcolor="#A6FFFF"><font face="바탕">상호/성명</font></td>
            <td style="font-size : 8pt;" width="18%" align="center" bgcolor="#A6FFFF"><font face="바탕">생년월일<br>(운전면허번호)</font></td>
            <td style="font-size : 8pt;" width="15%" align="center" bgcolor="#A6FFFF"><font face="바탕">사업자등록번호</font></td>
            <td style="font-size : 8pt;" width="18%" align="center" bgcolor="#A6FFFF"><font face="바탕">임대기간</font></td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td height="2" colspan="2"></td>
    </tr>
  </table>
  
  <%if(start_num!=0 && end_num !=0){%>	<!-- 해당건만 표시(2018.03.29) -->
  <table width='670' height="" border="0" cellpadding="0" cellspacing="0">
    <tr bgcolor="#000000">
		<td width="100%" height="10" align='center'>
			<table width="100%" border="0" cellspacing="1" cellpadding="0">
				<% if(FineList.size()>0){
					int num = 0;
					for(int i=0; i<FineList.size(); i++){
						if((i+1) >= start_num && (i+1) <= end_num){
							num++;
							FineDocListBn = (FineDocListBean)FineList.elementAt(i); 
				%>
				<tr bgcolor="#FFFFFF" align="center">
					<td width="4%" height="<%=line_h%>" bgcolor="#FFFFFF" style="font-size : 8pt;"><font face="바탕"><%=num%></font></td>
					<td width="14%" style="font-size : 10pt;"><font face="바탕"><%=FineDocListBn.getPaid_no()%></font></td>
					<td width="11%" style="font-size : 10pt;"><font face="바탕"><%=FineDocListBn.getCar_no()%></font></td>
					<td width="15%" style="font-size : 8pt;"><font face="바탕"><%=FineDocListBn.getFirm_nm()%></font></td>
					<td width="18%" style="font-size : 8pt;"><font face="바탕">
						<%if(FineDocListBn.getClient_st().equals("1")){ //법인사업자
								if(!FineDocListBn.getSsn().equals("")){%>
 									<%=FineDocListBn.getSsn() %>
						<%	}else{ //법인번호없는 법인사업자의 경우 대표자의 운전면허번호 기재(20191008)	%>
							<%if(!FineDocListBn.getLic_no().equals("")){ %>
								<%if(FineDocListBn.getLic_no().length()==12){ %>
    								(<%=FineDocListBn.getLic_no().substring(0,4)%>-<%=FineDocListBn.getLic_no().substring(4,10)%>-<%=FineDocListBn.getLic_no().substring(10,12)%>)
    							<%}else{ %>
    								<%if(FineDocListBn.getLic_no().equals("0")){%><%}else{%>(<%=FineDocListBn.getLic_no()%>)<%}%>
    							<%} %>
   							<%} %>
						<%	} %>
  						<%}else if(FineDocListBn.getClient_st().equals("6")){ //경매장%>
       						(경매장)
   						<%}else{ //개인, 개인사업자%>
       						<%=String.valueOf(FineDocListBn.getSsn()).substring(0,6) %><br>
							<%if(FineDocListBn.getLic_no().length()==12){ %>
	            				(<%=FineDocListBn.getLic_no().substring(0,4)%>-<%=FineDocListBn.getLic_no().substring(4,10)%>-<%=FineDocListBn.getLic_no().substring(10,12)%>)
	            			<%}else{ %>
	            				(<%=FineDocListBn.getLic_no()%>)
	            			<%} %>
   						<%} %>
					</font></td>
					<td width="15%" style="font-size : 8pt;"><font face="바탕"><%=AddUtil.ChangeEnt_no(FineDocListBn.getEnp_no())%></font></td>
					<td width="18%" style="font-size : 8pt;"><font face="바탕"><%=FineDocListBn.getRent_start_dt()+" 00:00"%>~<br>
					   <%=FineDocListBn.getRent_end_dt()+" 24:00"%>
					   </font></td>
				</tr>
				<tr bgcolor="#FFFFFF" align="">
					<td colspan="7">&nbsp;&nbsp;&nbsp;고지서 발송주소 : ( <%=FineDocListBn.getHo_zip()%> ) &nbsp;<%if(!FineDocListBn.getHo_addr().equals("")){%><%=FineDocListBn.getHo_addr()%><%}else{%>사업자등록증 확인요망.<%}%></td>
				</tr>
				<tr> 
					<td height="2" bgcolor="#FFFFFF" colspan="7"></td>
				</tr>
				<%		} 	
					}
				}	 %>
			</table>
		</td>
    </tr>
  </table>
  <%}else{ %>
  <table width='670' height="<%=table2_h%>" border="0" cellpadding="0" cellspacing="0">
    <tr bgcolor="#000000">
		<td width="100%" height="10" align='center'>
			<table width="100%" border="0" cellspacing="1" cellpadding="0">
				<% if(FineList.size()>0){
					for(int i=0; i<FineList.size(); i++){ 
						FineDocListBn = (FineDocListBean)FineList.elementAt(i); 
				%>
				<tr bgcolor="#FFFFFF" align="center">
					<td width="4%" height="<%=line_h%>" bgcolor="#FFFFFF" style="font-size : 8pt;"><font face="바탕"><%=i+1%></font></td>
					<td width="14%" style="font-size : 10pt;"><font face="바탕"><%=FineDocListBn.getPaid_no()%></font></td>
					<td width="11%" style="font-size : 10pt;"><font face="바탕"><%=FineDocListBn.getCar_no()%></font></td>
					<td width="15%" style="font-size : 8pt;"><font face="바탕"><%=FineDocListBn.getFirm_nm()%></font></td>
					<td width="18%" style="font-size : 8pt;"><font face="바탕">
						<%if(FineDocListBn.getClient_st().equals("1")){ //법인사업자
								if(!FineDocListBn.getSsn().equals("")){%>
 									<%=FineDocListBn.getSsn() %>
						<%	}else{ //법인번호없는 법인사업자의 경우 대표자의 운전면허번호 기재(20191008)	%>
							<%if(!FineDocListBn.getLic_no().equals("")){ %>
								<%if(FineDocListBn.getLic_no().length()==12){ %>
    								(<%=FineDocListBn.getLic_no().substring(0,4)%>-<%=FineDocListBn.getLic_no().substring(4,10)%>-<%=FineDocListBn.getLic_no().substring(10,12)%>)
    							<%}else{ %>
    								<%if(FineDocListBn.getLic_no().equals("0")){%><%}else{%>(<%=FineDocListBn.getLic_no()%>)<%}%>
    							<%} %>
   							<%} %>
						<%	} %>
  						<%}else if(FineDocListBn.getClient_st().equals("6")){ //경매장%>
       						(경매장)
   						<%}else{ //개인, 개인사업자%>
       						<%=String.valueOf(FineDocListBn.getSsn()).substring(0,6) %><br>
            				<%if(!FineDocListBn.getLic_no().equals("")){ %>
								<%if(FineDocListBn.getLic_no().length()==12){ %>
					        		(<%=FineDocListBn.getLic_no().substring(0,4)%>-<%=FineDocListBn.getLic_no().substring(4,10)%>-<%=FineDocListBn.getLic_no().substring(10,12)%>)
					        	<%}else{ %>
					        		(<%=FineDocListBn.getLic_no()%>)
					        	<%} %>
				        	<%} %>
   						<%} %>
					</font></td>
					<td width="15%" style="font-size : 8pt;"><font face="바탕"><%=AddUtil.ChangeEnt_no(FineDocListBn.getEnp_no())%></font></td>
					<td width="18%" style="font-size : 8pt;"><font face="바탕"><%=FineDocListBn.getRent_start_dt()+" 00:00"%>~<br>
					   <%=FineDocListBn.getRent_end_dt()+" 24:00"%>
					   </font></td>
				</tr>
				<tr bgcolor="#FFFFFF" align="">
					<td colspan="7">&nbsp;&nbsp;&nbsp;고지서 발송주소 : ( <%=FineDocListBn.getHo_zip()%> ) &nbsp;<%if(!FineDocListBn.getHo_addr().equals("")){%><%=FineDocListBn.getHo_addr()%><%}else{%>사업자등록증 확인요망.<%}%></td>
				</tr>
				<tr> 
					<td height="2" bgcolor="#FFFFFF" colspan="7"></td>
				</tr>
				<% 	}
				} %>
			</table>
		</td>
    </tr>
  </table>
  <%} %>
  
  <%if(tot_size > 3 ){%>
	<p style='page-break-before:always'><br style="height:0; line-height:0"></P>
	<%}%>
  <table width='670' height="" border="0" cellpadding="0" cellspacing="0">
	<tr> 
      <td colspan=2 align='right' height="20" style="font-size : 10pt;"><font face="바탕">- 끝 -</font></td>
    </tr>
    <tr> 
      <td colspan=2 height="20"><font face="바탕">&nbsp;</font></td>
    </tr>
    <tr> 
      <td colspan=2 height="20" style="font-size : 10pt;"><font face="바탕"># 첨&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
        부</font></td>
    </tr>
    <%for(int i=0; i<app_doc_size; i++){%>
    <tr> 
      <td width="13%" height="20" style="font-size : 10pt;"><font face="바탕">&nbsp;</font></td>
      <td width="87%" height="20" style="font-size : 10pt;"><font face="바탕">
        <%if(app_doc_v.substring(i,i+1).equals("1")){%>
        1) <%=var3%> 
        <%}%>
        <%if(app_doc_v.substring(i,i+1).equals("2")){%>
        2) <%=var4%> 
        <%}%>
        <!-- 신분증사본 삭제(20190910) -->
        <%-- <%if(app_doc_v.substring(i,i+1).equals("3")){%>
        &nbsp;&nbsp;&nbsp;&nbsp;<%=var5%> 
        <%}%> --%>
        <%if(app_doc_v.substring(i,i+1).equals("4")){%>
        3) <%=var6%> 
        <%}%>
        </font></td>
    </tr>
    <%}%>
    <tr> 
      <td colspan="2"><font face="바탕">&nbsp;</font></td>
    </tr>
    <tr align="center"> 
      <td height="140" colspan="2" style="font-size : 19pt;">
      	<div style="position: relative;">
      		<font face="바탕" style="z-index: 1;"><b>주식회사 아마존카 대표이사 조&nbsp;&nbsp;성&nbsp;&nbsp;희</b></font>
      		<img src="/acar/images/stamp.png" style="position:absolute; z-index: 2; left:545px; bottom: -20px; width: 77px;">
      	</div>		
      </td>
    </tr>
  </table>
</form>
</body>
</html>
<script language="JavaScript" type="text/JavaScript">	

	function onprint(){
		factory.printing.header 	= ""; //폐이지상단 인쇄
		factory.printing.footer 	= ""; //폐이지하단 인쇄
		factory.printing.portrait 	= true; //true-세로인쇄, false-가로인쇄    
		factory.printing.leftMargin 	= 12.0; //좌측여백   
		factory.printing.rightMargin 	= 12.0; //우측여백
		factory.printing.topMargin 	= 20.0; //상단여백    
		factory.printing.bottomMargin 	= 10.0; //하단여백
		<%if(FineDocBn.getPrint_dt().equals("")){%>
		factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
		<%}%>
	}

</script>
