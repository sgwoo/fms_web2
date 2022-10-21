<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	//chrome 관련 
	String height = request.getParameter("height")==null?"":request.getParameter("height");
	
	int count =0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector vt = a_db.getRentBoardList(s_kd, t_wd, gubun1, gubun2, st_dt, end_dt, sort, asc);
	int vt_size = vt.size();
	
	
	String valus = 	"?height="+height+"&auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort="+sort+"&asc="+asc+					
				   	"&sh_height="+sh_height+"";
	
%>

<html style="overflow: hidden;">
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<head><title>FMS</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript" src="/include/table_fix.js?ver=0.2"></script>
<link rel="stylesheet" type="text/css" href="/include/table_t.css?ver=0.2">
<link rel="stylesheet" type="text/css" href="/include/table_fix.css?ver=0.2">
	
<script language='javascript'>
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
		return;
	}				
	
	// 차량번호판 작업용 출력 항목 전체 선택
	function allCheckPrintCar(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "check_print_car"){		
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}
		}
		return;
	}
	
	//스캔등록
	function scan_file(tint_st, content_code, content_seq){
		window.open("/fms2/car_tint/reg_scan.jsp<%=valus%>&tint_st="+tint_st+"&content_code="+content_code+"&content_seq="+content_seq, "SCAN", "left=300, top=300, width=720, height=300, scrollbars=yes, status=yes, resizable=yes");
	}	
	
	// 차량번호판 작업용 출력
	function openPopupPrintCar(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "check_print_car"){		
				if(ck.checked){
					++cnt;
				}
			}
		}
		if(cnt == 0){
			alert('체크된 항목이 없습니다.');
			return;
		}
		
		var userAgent = navigator.userAgent.toLowerCase();
		if (userAgent.indexOf("edge") > -1 || userAgent.indexOf("whale") > -1 || userAgent.indexOf("chrome") > -1 || userAgent.indexOf("firefox") > -1 || userAgent.indexOf("safari") > -1) {
	 		var name = "printCar";
	 		var url = "print_estcarno.jsp";
	 		var status = "left=300, top=200, width=800, height=900, scrollbars=yes";
			window.open(url, name, status);
			fm.target = name;
			fm.action = url;
	 	} else {
			var name = "_blank";
			window.open('', name);
			fm.target = name;
			fm.action = "print_estcarno.jsp";
	 	}
		fm.method = "POST";
		fm.submit();
	}
	
 //-->   
</script>

</head>
<body>

<form name='form1'  id="form1" action='' method='post' target='d_content'>
  <input type='hidden' name='height' id="height" value='<%=height%>'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>   
  <input type='hidden' name='sort' 	value='<%=sort%>'>  
  <input type='hidden' name='asc' 	value='<%=asc%>'>     
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='mod_st' value='1'>
  <input type='hidden' name='ins_com_id' value=''>
  <input type='hidden' name='from_page' value='/fms2/car_pur/pur_doc_frame.jsp'>
 
 
<div class="tb_wrap">
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 560px;">
					<div style="width: 560px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>  
                    			<td style="width: 30px;" class='title title_border'>연번</td>
							    <td style="width: 30px;"  class='title title_border'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>				  									
								<td style="width: 60px;"  class='title title_border'>구분</td>
								<td style="width: 120px;" class='title title_border'>계약번호</td>
			        		    <td style="width: 90px;"  class='title title_border'>계약일</td>
					            <td style="width: 110px;" class='title title_border'>고객</td>
					            <td style="width: 60px;"  class='title title_border'>최초영업</td>
					            <td style="width: 60px;"  class='title title_border'>계약진행<br>담당자</td>
							</tr>
						</table>
					</div>
				</td>
				<td>
					<div>
						<table class="inner_top_table table_layout" style="height: 60px;">	
						
							 <colgroup>
				       			<col width="50">
				       			<col width="150">
				       			<col width="50">
				       			<col width="70">
				       			       				       					       			
				       			<col width="120">
				       			<col width="90">
				       			<col width="110">
				       			<col width="90">		       							      
												      
				       			<col width="110">
				       			<col width="90">			       			
				       			<col width="150">		       			
				       			<col width="150">		
				       			<col width="40">
				       			<col width="90">
				       						       			
				       			<col width="70">		       			
				       			<col width="70">	
				       				   
				       			<col width="100">
				       			<col width="100">
				       			<col width="110">			       			
				       			<col width="90">		       			
				       			<col width="90">
				       					   
				       			<col width="90">
				       			<col width="50">
				       						       			
				       			<col width="50">		       			
				       			<col width="130">
				       					   
				       			<col width="90">
				       			<col width="100">			       			
				       			<col width="80">		       			
				       			<col width="110">		
				       			<col width="70">		            			
				       		</colgroup>
												
							<tr>
					       		  <td colspan="4" class='title title_border'>기초사항</td>						  
								  <td colspan="4" class='title title_border'>차량출고</td>
								  <td colspan="6" class='title title_border'>등록진행</td>
								  <td colspan="2" class='title title_border'>담당자</td>
								  <td colspan="5" class='title title_border'>차량출고2</td>
								  <td colspan="2" class='title title_border'>기초사항2</td>
								  <td colspan="2" class='title title_border'>블랙박스</td>
								  <td colspan="5" class='title title_border'>납품</td>
								  <!-- <td colspan="6" class='title'>출고전진행업무</td> -->				  	                 	
			        	    </tr>
			        		<tr>
			        		   	  <td style="width: 50px;"  class='title title_border'>용도</td>
							      <td style="width: 150px;" class='title title_border'>차명</td>
							      <td style="width: 50px;"  class='title title_border'>등록지</td>
							      <td style="width: 70px;"  class='title title_border'>인수지</td>
							      
							      <td style="width: 120px;"   class='title title_border'>계출번호</td>
							      <td style="width: 90px;"   class='title title_border'>출고점</td>
							      <td style="width: 110px;"  class='title title_border'>연락처</td>
							      <td style="width: 90px;"   class='title title_border'>출고지</td>
							      
							      <td style="width: 110px;"  class='title title_border'>등록예정일</td>
							      <td style="width: 90px;"   class='title title_border'>지급일자</td>
							      <td style="width: 150px;"   class='title title_border'>
								      <input type="checkbox" name="all_check_print_car" onclick="javascript: allCheckPrintCar();">
								      차량번호
								      <a href="javascript:openPopupPrintCar();" title="차량번호판 작업용 출력">
								      	<img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="차량번호판 작업용 출력">
								      </a>
							      </td>
								  <td style="width: 150px;"  class='title title_border'>차대번호</td>
								  <td style="width: 40px;"   class='title title_border'>도착</td>
								  <td style="width: 90px;"   class='title title_border'>등록일자</td>
								  
								  <td style="width: 70px;" class='title title_border'>영업담당</td>				  				  
							      <td style="width: 70px;" class='title title_border'>관리담당</td>
							      
							      <td style="width: 100px;"  class='title title_border'>대출기관</td>
							      <td style="width: 100px;"  class='title title_border'>취득세명의변경</td>
							      <td style="width: 110px;"  class='title title_border'>출고예정일</td>
							      <td style="width: 90px;"   class='title title_border'>인수예정일</td>
							      <td style="width: 90px;"   class='title title_border'>마감요청일</td>	
				
							      <td style="width: 90px;"  class='title title_border'>색상</td>	
							      <td style="width: 50px;"  class='title title_border'>썬팅</td>
							      
							      <td style="width: 50px;"  class='title title_border'>유무</td>
							      <td style="width: 130px;" class='title title_border'>제조사</td>
							      
							      <td style="width: 90px;"   class='title title_border'>납품지</td>
							      <td style="width: 100px;"  class='title title_border'>납품예정일</td>
							      <td style="width: 80px;"   class='title title_border'>차량인도일</td>
							      <td style="width: 110px;"  class='title title_border'>탁송업체</td>
							      <td style="width: 70px;"   class='title title_border'>대여구분</td>	
			        		</tr>
	        		
						</table>
					</div>
				</td>
			</tr>
		</table>
	</div>
	
	<div class="tb_box">
		<table class="tb">
			<tr>
				<td style="width: 560px;">
					<div style="width: 560px;">
						<table class="inner_top_table left_fix">  
			  
						
					<%if (vt_size > 0) {%>
					<%
							for(int i = 0 ; i < vt_size ; i++) {
								Hashtable ht = (Hashtable)vt.elementAt(i);
					%>
							<tr style="height: 25px;"> 
								<td  width="30" class='center content_border'><%=i+1%></td><!-- 연번 -->
								<td  width="30" class='center content_border'><input type="checkbox" name="ch_cd" value="<%=ht.get("RENT_L_CD")%>"></td>	<!-- ㅁ -->				
								<td  width="60" class='center content_border'><%//=ht.get("SORT1")%><%//=ht.get("SORT2")%><%//=ht.get("SORT3")%><%=ht.get("RENT_ST")%></td><!-- 구분 -->
								<td  width="120" class='center content_border'><a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("USE_YN")%>')" onMouseOver="window.status=''; return true"><%=ht.get("RENT_L_CD")%></a></td><!-- 계약번호 -->
								<td  width="90" class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td><!-- 계약일 -->
								<td  width="110" class='center content_border'><span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 6)%></span><a href="javascript:parent.view_client('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '1', '<%=ht.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true"></a></td><!-- 고객 -->
								<td  width="60" class='center content_border'>
								  	<%-- <a href="javascript:parent.req_fee_start_act('신차 주차장 입고 통보', '<%=ht.get("RPT_NO")%> | <%=ht.get("FIRM_NM")%> | <%=ht.get("CAR_NM")%><%if(String.valueOf(ht.get("CAR_NO")).length()==7||String.valueOf(ht.get("CAR_NO")).length()==8){%> | <%=ht.get("CAR_NO")%><%}%> 도착. 2시30분에 탁송보내세요.', '<%=ht.get("BUS_ID")%>', '<%=ht.get("AGENT_EMP_NM")%>', '<%=ht.get("AGENT_EMP_M_TEL")%>','<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='최초영업자에게 신차 주차장 입고 통보하기'> --%>
								  	<a href="javascript:parent.req_fee_start_act2('신차 주차장 입고 통보', '<%=ht.get("RPT_NO")%> | <%=ht.get("FIRM_NM")%> | <%=ht.get("CAR_NM")%><%if(String.valueOf(ht.get("CAR_NO")).length()==7||String.valueOf(ht.get("CAR_NO")).length()==8){%> | <%=ht.get("CAR_NO")%><%}%> 도착. 2시30분에 탁송보내세요.', '<%=ht.get("RPT_NO")%>', '<%=ht.get("FIRM_NM")%>', '<%=ht.get("CAR_NM")%>', '<%if (String.valueOf(ht.get("CAR_NO")).length() == 7 || String.valueOf(ht.get("CAR_NO")).length() == 8) {%><%=ht.get("CAR_NO")%><%}%>', '<%=ht.get("BUS_ID")%>', '<%=ht.get("AGENT_EMP_NM")%>', '<%=ht.get("AGENT_EMP_M_TEL")%>','<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='최초영업자에게 신차 주차장 입고 통보하기'>
								    	<%=ht.get("BUS_NM")%>
								  	</a>
								</td><!-- 최초영업 -->
								<td width="60" class='center content_border'><span title='<%=ht.get("AGENT_EMP_M_TEL")%>'><%=ht.get("AGENT_EMP_NM")%></span></td><!-- 계약진행 담당자 -->
							</tr>
			      <%		}%>
			         <%} else  {%>  
				           	<tr>
								<td class='center content_border'>등록된 데이타가 없습니다</td>
						    </tr>	              
				     <%}	%>
					</table>
	           	</div>            
		    </td>
		    <td>			
		     	 <div>
					<table class="inner_top_table table_layout">   	   
	    
		            <%	if(vt_size > 0) {%>	
					<%		for(int i = 0 ; i < vt_size ; i++){
							Hashtable ht = (Hashtable)vt.elementAt(i);%>			
						<tr style="height: 25px;"> 
							<td  width='50' class='center content_border'><%if(String.valueOf(ht.get("CAR_ST")).equals("리스")){%><font color=red><%}%><%if(String.valueOf(ht.get("CAR_ST")).equals("업무대여")){%>렌트<%}else{%><%=ht.get("CAR_ST")%><%}%><%if(String.valueOf(ht.get("CAR_ST")).equals("리스")){%></font><%}%></td><!-- 용도 -->
							<td  width='150' class='center content_border'>
								<%if(ht.get("JG_G_16").equals("1")){ %><span style="color:red; letter-spacing: -1px;">[저공해]</span><%}%>
								<%if(ht.get("JG_G_7").equals("3")){ %><span style="color:darkorange; letter-spacing: -1px;">[전]</span><%}%>
								<%if(ht.get("JG_G_7").equals("4")){ %><span style="color:darkorange; letter-spacing: -1px;">[수]</span><%}%>
								<%if(ht.get("HOOK_YN").equals("Y")){ %><span style="color:#00b749; letter-spacing: -1px;">[견인]</span><%}%>
								<span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 6)%></span>
							</td><!-- 차명 -->
							<td  width='50' class='center content_border'><%=ht.get("CAR_EXT")%></td><!-- 등록지역 -->
							<td  width='70' class='center content_border'><%=ht.get("UDT_ST")%></td><!-- 인수지 -->
							
							<td  width='120' class='center content_border'><%=ht.get("RPT_NO")%></td><!-- 계출번호 -->
							<td  width='90' class='center content_border'>
								<%if(String.valueOf(ht.get("DLV_BRCH")).equals("B2B사업운영팀")||String.valueOf(ht.get("DLV_BRCH")).equals("법인판촉팀")||String.valueOf(ht.get("DLV_BRCH")).equals("법인판매팀")||String.valueOf(ht.get("DLV_BRCH")).equals("특판팀")){%>
								  <span title='<%=ht.get("DLV_BRCH")%>'><a href="javascript:parent.req_dlv_emp_act('출고담당자 제작증 요청','<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=AddUtil.ChangeDate3(String.valueOf(ht.get("REG_EST_DT")))%>','<%=ht.get("CAR_NM")%>','<%=ht.get("RPT_NO")%>')" onMouseOver="window.status=''; return true" title='출고담당자에게 제작증 요청 문자 보내기' style="color:red"><%=Util.subData(String.valueOf(ht.get("DLV_BRCH")), 5)%></a></span>
								<%}else{%>  
								  <span title='<%=ht.get("DLV_BRCH")%>'><a href="javascript:parent.req_dlv_emp_act('출고담당자 제작증 요청','<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=AddUtil.ChangeDate3(String.valueOf(ht.get("REG_EST_DT")))%>','<%=ht.get("CAR_NM")%>','<%=ht.get("RPT_NO")%>')" onMouseOver="window.status=''; return true" title='출고담당자에게 제작증 요청 문자 보내기'><%=Util.subData(String.valueOf(ht.get("DLV_BRCH")), 5)%></a></span>
								<%}%>
							</td><!-- 출고점 -->
							<td  width='110' class='center content_border'><%=ht.get("CAR_OFF_TEL")%></td><!-- 연락처 -->
							<td  width='90' class='center content_border'><%=Util.subData(String.valueOf(ht.get("DLV_EXT")), 5)%></td><!-- 출고지 -->
							
							<td width='110' class='center content_border'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("REG_EST_DT")))%></td><!-- 등록예정일 -->
							<td  width='90' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PUR_PAY_DT")))%>
							<%if(String.valueOf(ht.get("PUR_PAY_DT")).equals("") && !String.valueOf(ht.get("DOC_USER_DT2")).equals("")){%>
							<%=AddUtil.ChangeDate2(String.valueOf(ht.get("DOC_USER_DT2")))%>
							<%}%>
							</td><!-- 지급일자 -->
							<td width='150' class='center content_border'> 
							<%
								int isNewPlate = 1;
								if(String.valueOf(ht.get("NEW_LICENSE_PLATE")).equals("1") || String.valueOf(ht.get("NEW_LICENSE_PLATE")).equals("2")){
							%>
							<!-- <span style="color:red; letter-spacing: -1px;">[신형]</span> -->
							<%}else{
								isNewPlate = 2;
							%>
							<span style="color:red; letter-spacing: -1px;">(구)</span>
							<%} %> 
							<%if(!String.valueOf(ht.get("CAR_NO")).equals("")){%>
								<input type="checkbox" name="check_print_car" style="margin: 0;" value="<%=String.valueOf(ht.get("CAR_NO"))%>/<%=String.valueOf(ht.get("CAR_NUM"))%>/<%=String.valueOf(ht.get("CAR_NM"))%>">
							<%}%> 
							<%if(String.valueOf(ht.get("INIT_REG_DT")).equals("")){%>
								<a href="javascript:parent.reg_estcarno ('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=ht.get("CAR_ST")%>','<%=ht.get("UDT_ST")%>','<%=isNewPlate%>');"><%=ht.get("CAR_NO")%> </a>
								<%if(String.valueOf(ht.get("CAR_NO")).equals("")){%>
									<a href="javascript:parent.reg_estcarno('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=ht.get("CAR_ST")%>','<%=ht.get("UDT_ST")%>','<%=isNewPlate%>');" class="btn"><img src=/acar/images/center/button_in_hmnum.gif align=absmiddle border=0></a>
								<%}%>
							<%}else{%>
								<%=ht.get("CAR_NO")%>
							<%}%>
							</td><!-- 차량번호 -->					
							<td  width='150' class='center content_border'><%if(String.valueOf(ht.get("INIT_REG_DT")).equals("")){%><a href="javascript:parent.reg_estcarnum('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>');"><%=ht.get("CAR_NUM")%></a><%if(String.valueOf(ht.get("CAR_NUM")).equals("")){%><a href="javascript:parent.reg_estcarnum('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>');" class="btn"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a><%}%><%}else{%><%=ht.get("CAR_NUM")%><%}%></td><!-- 차대번호 -->
							<td  width='40' class='center content_border'>
								<%if(String.valueOf(ht.get("ARRIVAL_DT")).equals("")){%>
									<%if(String.valueOf(ht.get("TO_EST_DT")).equals("")){%>
									<%}else{%>
										<span title='<%=AddUtil.ChangeDate3(String.valueOf(ht.get("TO_EST_DT")))%>'><span style="color:red;"><%=ht.get("TO_EST_DT_H")%>시</span></span>
									<%}%>
								<%}else{%>
									<span title='<%=ht.get("ARRIVAL_DT")%>'>유</span>
								<%}%>
							</td><!-- 도착 2017.12.11 수정-->
							<td  width='90' class='center content_border'><%if(String.valueOf(ht.get("INIT_REG_DT")).length()>0){%><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))%><%}else{%><a href="javascript:parent.carRegList('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=ht.get("CAR_MNG_ID")%>','<%=ht.get("REG_GUBUN")%>','<%=ht.get("UDT_ST")%>');" class="btn"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a><%}%></td><!-- 등록일자 -->
		
							<td  width='70' class='center content_border'><%=ht.get("BUS_NM2")%></td><!-- 담당자 영업담당 -->
							<td  width='70' class='center content_border'><%=ht.get("MNG_NM")%></td><!-- 담당자 관리담당 -->
		
							<td  width='100' class='center content_border'><span title='<%=ht.get("CPT_NM")%>'><%=Util.subData(String.valueOf(ht.get("CPT_NM")), 6)%></span></td><!-- 대출기관 -->
							<td  width='100' class='center content_border'><%if(String.valueOf(ht.get("ACQ_CNG_YN")).equals("있음")){%><span title='<%=c_db.getNameById(String.valueOf(ht.get("CPT_CD")),"BANK")%>'><%=Util.subData(c_db.getNameById(String.valueOf(ht.get("CPT_CD")),"BANK"), 6)%></span><%}%></td><!-- 취득세명의변경 -->
							<td  width='110' class='center content_border'><a href="javascript:parent.view_est('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>');"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("DLV_EST_DT")))%></a></td><!-- 출고예정일 -->
							<td  width='90' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("UDT_EST_DT")))%></td><!-- 인수예정일 -->
							<td width='90' class='center content_border'>
							<%if(String.valueOf(ht.get("TINT_NO2")).equals("")){%>
							<%=AddUtil.ChangeDate2(String.valueOf(ht.get("SUP_EST_DT")))%>
							<%}else{%>
							<%=AddUtil.ChangeDate2(String.valueOf(ht.get("SUP_EST_DT2")))%>
							<%}%>
							</td><!-- 마감요청일 -->
							
							<td  width='90' class='center content_border'><span title='<%=ht.get("COLO")%>'><%=Util.subData(String.valueOf(ht.get("COLO")), 5)%></span></td><!-- 색상 -->
							<td  width='50' class='center content_border'><%=ht.get("SUN_PER")%>%</td><!-- 썬팅 -->
							
							<td  width='50' class='center content_border'>
							<% if(!String.valueOf(ht.get("CAR_COMP_ID")).equals("0056")){ %>
								<%if(String.valueOf(ht.get("TINT_NO2")).equals("")){%>
		                              <%=ht.get("BLACKBOX_YN_NM")%>
								<%}else{%>
								<%=ht.get("B_YN")%>
								<%}%>
							<%}else{%>
								장착
							<%}%>
												
							</td><!-- 블랙박스 유무 -->
							<td  width='130' class='center content_border'>
							
							<% if(!String.valueOf(ht.get("CAR_COMP_ID")).equals("0056")){ %>
								<%if(!String.valueOf(ht.get("TINT_NO2")).equals("")){%>
									<span title='<%=ht.get("B_COM_NM")%>'><%=Util.subData(String.valueOf(ht.get("B_COM_NM")), 5)%></span>
								<%}%>					
							<%}else{%>
								<span title='<%=ht.get("B_COM_NM")%>'>내장형</span>
							<%}%>
							</td><!-- 블랙박스 제조사 -->
							
							<td  width='90' class='center content_border'><span title='<%=ht.get("RENT_EXT")%>'><%=Util.subData(String.valueOf(ht.get("RENT_EXT")), 6)%></span></td><!-- 납품지 -->
							<td  width='100' class='center content_border'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("RENT_EST_DT")))%></td><!-- 납품예정일 -->
							<td  width='80' class='center content_border'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CAR_DELI_DT")))%></td><!-- 차량인도일 -->
							<td  width='110' class='center content_border'><%=Util.subData(String.valueOf(ht.get("OFF_NM")), 7)%></td><!-- 탁송업체 -->
							<td  width='70' class='center content_border'><%if(String.valueOf(ht.get("RENT_WAY")).equals("일반식")){%><font color=red><%}%><%=ht.get("RENT_WAY")%><%if(String.valueOf(ht.get("RENT_WAY")).equals("일반식")){%></font><%}%></td>	<!-- 대여구분 -->
							
							<!-- 2018.1.4 제거 -->
							<%-- <td  width='70' align='center'>
								<%if(String.valueOf(ht.get("ECO_E_TAG")).equals("1")){%>
								발급
								<%}%>
							</td><!-- 맑은서울 -->
							<td  width='90' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("DLV_DT")))%></td><!-- 출고일자 -->
							<td  width='90' align='center'><%=ht.get("PP_ST")%></td><!-- 초기선납금 -->
							<td  width='90' align='center'><%=ht.get("GI_ST")%></td><!-- 보증보험 -->
							<td  width='90' align='center'><%=ht.get("INS_ST")%></td><!-- 종합보험 -->
							<td  width='100' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("CAR_AMT")))%>원</td><!-- 차량대금 --> --%>
							<%-- <td  width='90' align='center'><%if(String.valueOf(ht.get("INIT_REG_DT")).equals("")){%><a href="javascript:parent.reg_estcarno('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>');"><%=ht.get("CAR_NO")%></a><%if(String.valueOf(ht.get("CAR_NO")).equals("")){%><a href="javascript:parent.reg_estcarno('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>');" class="btn"><img src=/acar/images/center/button_in_hmnum.gif align=absmiddle border=0></a><%}%><%}else{%><%=ht.get("CAR_NO")%><%}%></td> --%><!-- 차량번호 -->
		
						</tr>
			 <%		}	%> 		
		      <%} else  {%>  
				       	<tr>
					       <td width="2900" colspan="29" class='center content_border'>&nbsp;</td>
					     </tr>	              
			   <%}	%>
				    </table>
			  </div>
			</td>
  		</tr>
		</table>
	</div>
</div>

</form>	 
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>

