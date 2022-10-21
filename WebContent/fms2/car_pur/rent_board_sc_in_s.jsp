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
	
	int count =0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector vt = a_db.getRentBoardList(s_kd, t_wd, gubun1, gubun2, st_dt, end_dt, sort, asc);
	int vt_size = vt.size();
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort="+sort+"&asc="+asc+					
				   	"&sh_height="+sh_height+"";
	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
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
	
	//스캔등록
	function scan_file(tint_st, content_code, content_seq){
		window.open("/fms2/car_tint/reg_scan.jsp<%=valus%>&tint_st="+tint_st+"&content_code="+content_code+"&content_seq="+content_seq, "SCAN", "left=300, top=300, width=720, height=300, scrollbars=yes, status=yes, resizable=yes");
	}
					
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onLoad="javascript:init()">
<form name='form1' method='post'>
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
<div style="overflow:auto">  
<table border="0" cellspacing="0" cellpadding="0" width='2240'>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>  
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='500' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
			    <tr>
			        <td width='30' class='title' style='height:51'>연번</td>
					<td width='30' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>				  									
					<td width='60' class='title'>구분</td>
	                <td width="110" class='title'>계약번호</td>
	                <td width="150" class='title'>고객</td>
	                <td width="60" class='title'>최초영업</td>
	                <td width="60" class='title'>계약진행<br>담당자</td>
			    </tr>
			</table>
		</td>
		<td class='line' width='1740'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
				  <td colspan="5" class='title'>기초사항</td>					
				  <td colspan="5" class='title'>차량출고</td>
				  <td colspan="7" class='title'>등록진행</td>				  
				  <td colspan="2" class='title'>블랙박스</td>				  
				  <td colspan="2" class='title'>담당자</td>				  
				</tr>
				<tr>
			      <td width='50' class='title'>용도</td>
			      <td width='90' class='title'>차명</td>
			      <td width='70' class='title'>맑은서울</td>				  
				  <td width='60' class='title'>등록지역</td>
				  <td width='80' class='title'>인수지</td>	
			      <td width='120' class='title'>계출번호</td>				  
			      <td width='90' class='title'>출고점</td>
			      <td width='100' class='title'>연락처</td>				  
			      <td width='90' class='title'>출고지</td>				  
				  <td width='90' class='title'>인수예정일</td>
				  <td width='90' class='title'>지급일자</td>
				  <td width='80' class='title'>차량번호</td>
				  <td width='140' class='title'>차대번호</td><!-- 2017. 12. 11 위치 변경 -->
				  <td width='40' class='title'>도착</td><!-- 2017. 12. 11 수정 -->
				  <td width='90' class='title'>등록일자</td><!-- 2017. 12. 11 위치 변경 -->
				  <td width='100' class='title'>취득세명의변경</td>
				  <td width='100' class='title'>납품지</td>			  				  			  
			      <td width='40' class='title'>유무</td>
			      <td width='100' class='title'>제조사</td>				  				  				  				  
			      <td width='60' class='title'>대여구분</td>
			      <td width='60' class='title'>관리담당</td>				  				  				  				  
			  </tr>
			</table>
		</td>
	</tr>
<%
	if(vt_size > 0)
	{
%>
	<tr>
		<td class='line' width='500' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
%>
				<tr>
					<td  width='30' align='center'><%=i+1%></td><!-- 연번 -->
					<td  width='30' align='center'><input type="checkbox" name="ch_cd" value="<%=ht.get("RENT_L_CD")%>"></td><!-- ㅁ -->										
					<td  width='60' align='center'><%//=ht.get("SORT1")%><%//=ht.get("SORT2")%><%//=ht.get("SORT3")%><%=ht.get("RENT_ST")%></td><!-- 구분 -->
					<td  width='110' align='center'><a href="javascript:parent.view_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("USE_YN")%>')" onMouseOver="window.status=''; return true"><%=ht.get("RENT_L_CD")%></a></td><!-- 계약번호 -->	
					<td  width='150' align='center'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 8)%><span title='<%=ht.get("FIRM_NM")%>'><a href="javascript:parent.view_client('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '1', '<%=ht.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true"></a></span></td><!-- 고객 -->
					<td  width='60' align='center'>
					  	<%-- <a href="javascript:parent.req_fee_start_act('신차 주차장 입고 통보', '<%=ht.get("RPT_NO")%> | <%=ht.get("FIRM_NM")%> | <%=ht.get("CAR_NM")%><%if(String.valueOf(ht.get("CAR_NO")).length()==7){%> | <%=ht.get("CAR_NO")%><%}%> 도착. 2시30분에 탁송보내세요.', '<%=ht.get("BUS_ID")%>', '<%=ht.get("AGENT_EMP_NM")%>', '<%=ht.get("AGENT_EMP_M_TEL")%>','<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='최초영업자에게 신차 주차장 입고 통보하기'> --%>
					  	<a href="javascript:parent.req_fee_start_act2('신차 주차장 입고 통보', '<%=ht.get("RPT_NO")%> | <%=ht.get("FIRM_NM")%> | <%=ht.get("CAR_NM")%><%if(String.valueOf(ht.get("CAR_NO")).length()==7||String.valueOf(ht.get("CAR_NO")).length()==8){%> | <%=ht.get("CAR_NO")%><%}%> 도착. 2시30분에 탁송보내세요.', '<%=ht.get("RPT_NO")%>', '<%=ht.get("FIRM_NM")%>', '<%=ht.get("CAR_NM")%>', '<%if (String.valueOf(ht.get("CAR_NO")).length() == 7 || String.valueOf(ht.get("CAR_NO")).length() == 8) {%><%=ht.get("CAR_NO")%><%}%>', '<%=ht.get("BUS_ID")%>', '<%=ht.get("AGENT_EMP_NM")%>', '<%=ht.get("AGENT_EMP_M_TEL")%>','<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='최초영업자에게 신차 주차장 입고 통보하기'>
					    	<%=ht.get("BUS_NM")%>
					  	</a>
					</td><!-- 최초영업 -->
					<td  width='60' align='center'><span title='<%=ht.get("AGENT_EMP_M_TEL")%>'><%=ht.get("AGENT_EMP_NM")%></span></td><!-- 계약진행 담당자 -->
				</tr>
<%
		}
%>
			</table>
		</td>
		<td class='line' width='1740'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>			
				<tr>
					<td  width='50' align='center'><%if(String.valueOf(ht.get("CAR_ST")).equals("리스")){%><font color=red><%}%><%if(String.valueOf(ht.get("CAR_ST")).equals("업무대여")){%>렌트<%}else{%><%=ht.get("CAR_ST")%><%}%><%if(String.valueOf(ht.get("CAR_ST")).equals("리스")){%></font><%}%></td><!-- 용도 -->
					<td  width='90' align='center'><span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 6)%></span></td><!-- 차명 -->
					<td  width='70' align='center'>
						<%if(String.valueOf(ht.get("ECO_E_TAG")).equals("1")){%>
						발급
						<%}%>
					</td><!-- 맑은 서울 -->
					<td  width='60' align='center'><%=ht.get("CAR_EXT")%></td><!-- 등록지역 -->	
					<td  width='80' align='center'><%=ht.get("UDT_ST")%></td><!-- 인수지 -->

					<td  width='120' align='center'><%=ht.get("RPT_NO")%></td><!-- 계출번호 -->	
					<td  width='90' align='center'>
						<%if(String.valueOf(ht.get("DLV_BRCH")).equals("B2B사업운영팀")||String.valueOf(ht.get("DLV_BRCH")).equals("법인판촉팀")||String.valueOf(ht.get("DLV_BRCH")).equals("법인판매팀")||String.valueOf(ht.get("DLV_BRCH")).equals("특판팀")){%>
						  <font color=red><span title='<%=ht.get("DLV_BRCH")%>'><%=Util.subData(String.valueOf(ht.get("DLV_BRCH")), 5)%></span></font>
						<%}else{%>  
						  <span title='<%=ht.get("DLV_BRCH")%>'><%=Util.subData(String.valueOf(ht.get("DLV_BRCH")), 5)%></span>
						<%}%>
					</td><!-- 출고점 -->
					<td  width='100' align='center' style="font-size:11px;"><%=ht.get("CAR_OFF_TEL")%></td><!-- 연락처 -->
					<td  width='90' align='center'><%=Util.subData(String.valueOf(ht.get("DLV_EXT")), 5)%></td><!-- 출고지 -->
					<td  width='90' align='center'><a href="javascript:parent.view_est('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>');"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("UDT_EST_DT")))%></a></td><!-- 인수예정일 -->	
					
					
					<td  width='90' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PUR_PAY_DT")))%>
					<%if(String.valueOf(ht.get("PUR_PAY_DT")).equals("") && !String.valueOf(ht.get("DOC_USER_DT2")).equals("")){%>
					<%=AddUtil.ChangeDate2(String.valueOf(ht.get("DOC_USER_DT2")))%>
					<%}%>
					</td><!-- 지급일자 -->
					<td  width='80' align='center'> <%if(String.valueOf(ht.get("INIT_REG_DT")).equals("")){%><a href="javascript:parent.reg_estcarno ('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=ht.get("CAR_ST")%>','<%=ht.get("UDT_ST")%>');"><%=ht.get("CAR_NO")%> </a><%if(String.valueOf(ht.get("CAR_NO")).equals("")){%><a href="javascript:parent.reg_estcarno('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=ht.get("CAR_ST")%>','<%=ht.get("UDT_ST")%>');" class="btn"><img src=/acar/images/center/button_in_hmnum.gif align=absmiddle border=0></a><%}%><%}else{%><%=ht.get("CAR_NO")%><%}%></td><!-- 차량번호 -->
					<td  width='140' align='center'><%if(String.valueOf(ht.get("INIT_REG_DT")).equals("")){%><a href="javascript:parent.reg_estcarnum('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>');"><%=ht.get("CAR_NUM")%></a><%if(String.valueOf(ht.get("CAR_NUM")).equals("")){%><a href="javascript:parent.reg_estcarnum('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>');" class="btn"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a><%}%><%}else{%><%=ht.get("CAR_NUM")%><%}%></td><!-- 차대번호 -->
					<td  width='40' align='center'><%if(String.valueOf(ht.get("ARRIVAL_DT")).equals("")){%><%}else{%><span title='<%=ht.get("ARRIVAL_DT")%>'>유</span><%}%></td><!-- 도착 2017. 12. 11 수정 -->
					<td  width='90' align='center'><%if(String.valueOf(ht.get("INIT_REG_DT")).length()>0){%><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))%><%}else{%><a href="javascript:parent.carRegList('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=ht.get("CAR_MNG_ID")%>','<%=ht.get("REG_GUBUN")%>','<%=ht.get("UDT_ST")%>');" class="btn"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a><%}%></td><!-- 등록일자 2017. 12. 11 위치변경 -->
					<td  width='100' align='center'><%if(String.valueOf(ht.get("ACQ_CNG_YN")).equals("있음")){%><span title='<%=c_db.getNameById(String.valueOf(ht.get("CPT_CD")),"BANK")%>'><%=Util.subData(c_db.getNameById(String.valueOf(ht.get("CPT_CD")),"BANK"), 6)%></span><%}%></td><!-- 취득세명의변경 -->
					<td  width='100' align='center'><span title='<%=ht.get("RENT_EXT")%>'><%=Util.subData(String.valueOf(ht.get("RENT_EXT")), 6)%></span></td><!-- 납품지 -->
						
					<td  width='40' align='center'>
					<%if(String.valueOf(ht.get("TINT_NO2")).equals("")){%>
                                        <%=ht.get("BLACKBOX_YN_NM")%>
					<%}else{%>
					<%=ht.get("B_YN")%>
					<%}%>					
					</td><!-- 유무 -->
					<td  width='100' align='center' style="font-size : 8pt;">
					<%if(!String.valueOf(ht.get("TINT_NO2")).equals("")){%>					    
					<span title='<%=ht.get("B_COM_NM")%>'><%=Util.subData(String.valueOf(ht.get("B_COM_NM")), 5)%></span>
					<%}%>						    
					</td><!-- 제조사 -->					
					<td  width='60' align='center'><%if(String.valueOf(ht.get("RENT_WAY")).equals("일반식")){%><font color=red><%}%><%=ht.get("RENT_WAY")%><%if(String.valueOf(ht.get("RENT_WAY")).equals("일반식")){%></font><%}%></td><!-- 대여구분 -->					
					<td  width='60' align='center'><%=ht.get("MNG_NM")%></td><!-- 관리담당 -->
				</tr>
<%
		}
%>
			</table>
		</td>
<%	}                  
	else               
	{
%>                     
	<tr>
		<td class='line' width='450' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>
					<%if(t_wd.equals("")){%>검색어를 입력하십시오.
					<%}else{%>등록된 데이타가 없습니다<%}%></td>
				</tr>
			</table>
		</td>
		<td class='line' width='1650'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
<%                     
	}                  
%>
</table>
</div>
</form>

<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>

