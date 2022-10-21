<%@ page contentType="text/html; charset=euc-kr"%>
<%@ page language="java"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.car_register.*, acar.cus_reg.*"%>
<jsp:useBean id="ch_bean" class="acar.car_register.CarHisBean" scope="page"/>
<%@ include file="/acar/cookies.jsp"%>

<%
	String param 	= request.getParameter("param")==null?"":request.getParameter("param");
	String modi_chk	= request.getParameter("modi_chk")==null?"0":request.getParameter("modi_chk");
	String[] params = param.split(",");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language="JavaScript">
$(document).ready(function(){
	//차령만료일 1회 연장시 현재팝업에서는 더이상 연장 불가 처리
	var modi_chk = '<%=modi_chk%>';
	if(modi_chk=="1"){
		$("#btn_carEndDt").css("display","none");
		$("#alert1").css("display","block");
	}
});
// 차령만료일 수정 및 차량번호변경 이력 신규생성  - 일괄버튼
function saveAllCarEndDt(){
	var fm = document.form1;
	//var url = document.location.href;
	if(confirm('현재 정보 그대로 일괄 수정 및 등록 됩니다.\n\n수정하시겠습니까?')){
		window.open('about:blank', "saveAllCarEndDt", "width=500, height=200");
		fm.target = "saveAllCarEndDt";		
		fm.action = "car_end_dt_modify_all_a.jsp";
		fm.submit();
	}
}

//2회 연장여부 변경  - 일괄버튼
function saveAllCarEndYn(){
	var fm = document.form1;
	if(confirm('"<차령만료일 연장>으로 2건 생성 및 등록증을 등록한 차량"의 2회연장 여부를 갱신 하시겠습니까?')){
		window.open('about:blank', "saveAllCarEndYn", "width=500, height=200");
		fm.target = "saveAllCarEndYn";		
		fm.action = "car_end_dt_modify_all_b.jsp";
		fm.submit();
	}
}

//스캔등록(각 건당)
function scan_reg(car_mng_id, cha_seq, car_no){
	window.open("reg_scan.jsp?car_mng_id="+car_mng_id+"&cha_seq="+cha_seq+"&subject="+car_no, "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
}	

//변경일자 일괄수정 버튼  - 일괄버튼
function modifyAllChaDt(){
	var length = '<%=params.length%>';
	for(var i=0; i<length; i++){
		if($("#cha_dt_"+i).val()!=""){
			//var data = $("#data_"+i).val() + $("#cha_dt_"+i).val();
			var data = $("#data_"+i).val() + $("#cha_dt_all").val();
			$("#data_"+i).val(data);
		}
	}
	var fm = document.form1;
	if(confirm('"차령만료일 1년 연장"사유로 연장한 자동차번호이력이 존재하면,\n\n가장 마지막 번호이력의 변경일자를 현재 상태 그대로 수정합니다.\n\n변경일자를 해당 날짜로 일괄 변경 하시겠습니까?')){
		window.open('about:blank', "modifyAllChaDt", "width=500, height=200");
		fm.target = "saveAllChaDt";		
		fm.action = "car_end_dt_modify_all_c.jsp";
		fm.submit();
	}
}

</script>
</head>
<body>
	<form name='form1' method='post'>
		<table width=1080 border=0 cellpadding=0 cellspacing=0>
		    <tr>
		        <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
		        <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>차령만료일 일괄변경</span></span></td>
		        <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
		    </tr>
		    <tr height="10px;"></tr>
		</table>
		<div style="font-size: 13px; padding-bottom: 10px; margin-top:20px; float: left;">
			<div style="margin-bottom: 10px;">① 차령만료일 변경시, 현재 차령만료일 기준 1년이 자동 갱신, 차번호이력등록건이 신규 생성(2건까지), 등록증 등록버튼이 생성됩니다.</div>
			<div style="margin-bottom: 10px;">② 생성된 등록버튼을 이용해 등록증을 등록합니다.<br> &nbsp;&nbsp;&nbsp;&nbsp;단, 일괄창에서는 등록증 중 가장 최신건 1건만 열람가능하므로 이전 변경건의 등록증을 삭제, 등록하려면 각차량의 상세 페이지에서 해야합니다.</div>
			<div style="margin-bottom: 10px;">③ 등록증 등록 후 2회연장 여부 변경시, 현재 등록된 "차량만료일연장"의 2건의 등록증을 체크 후 자동 연장종료 처리합니다. <br> &nbsp;&nbsp;&nbsp;&nbsp;(②의 이유로 최근 변경건의 등록증을 등록했어도 2회연장여부가 갱신되지 않을 수 있으니, 해당 차량은 상세페이지를 확인해주세요.)</div>
			<div>※ 버튼클릭 후 정상 수정 되었다는 메시지 후에도 화면이 새로고침 되지 않는 경우, 새로고침을 눌러주세요. </div>
			<div id="alert1" style="color: red; display:none;">※ 이미 차령만료일을 1회 연장하였습니다. 중복 클릭방지를 위해 현재 페이지에서는 더이상 차령만료일 연장을 제한합니다.</div>
			<br>
		</div>	
		<div align="right" style="position: relative; margin-right: 35px; margin-bottom: 20px;">
			<input type="button" class="button" id="btn_carEndDt" value="차령만료일 변경" onclick="javascript:saveAllCarEndDt()" style="margin-bottom: 15px; width: 130px;"><br>
			<input type="button" class="button" value="2회연장여부 변경" onclick="javascript:saveAllCarEndYn()" style="margin-bottom: 15px; width: 130px;"><br>
			<input type="text" id="cha_dt_all" name="cha_dt_all" style="margin-bottom: 2px; width: 130px;" placeholder="ex) 2018-01-23"><br>
			<input type="button" class="button" value="변경일자 일괄수정" onclick="javascript:modifyAllChaDt()" style="margin-bottom: 15px; width: 130px;"><br> 
			<input type="button" class="button" value="새로고침" onclick="javascript:window.location.reload();" style="width: 130px;">
		</div>
	
		<table border=0 cellspacing=0 cellpadding=0 width="100%">
			<tr>
				<td>
					<table border=0 cellspacing=0 cellpadding=0 width="100%">
						<tr>
							<td class=line2></td>
						</tr>
						<tr>
							<td class=line>
								<table border=0 cellspacing=1 width=100%>
									<tr>
										<td width=3% class=title>연번</td>
										<td width=15% class=title>등록증스캔</td>
										<td width=8% class=title>차량번호</td>
										<td width=16% class=title>차명</td>
										<td width=17% class=title>차령만료일</td>
										<td width=8% class=title>2회연장여부</td>
										<td width=8% class=title>관리번호</td>									
										<td width=8% class=title>변경일자</td>
									</tr>
								<%
								for(int i=0; i<params.length; i++){
									Vector vt = crd.getModifyCarEndDtList(params[i]);									
									int vt_size = vt.size();
									Hashtable ht = (Hashtable)vt.elementAt(0);
									String car_end_dt = (String)ht.get("CAR_END_DT");
									int year = Integer.parseInt(car_end_dt.substring(1,4));
									String new_car_end_dt = car_end_dt.substring(0,2) + Integer.toString(year+1) + car_end_dt.substring(4);
									
									CarHisBean ch_r [] = crd.getCarHisCarEndDt(params[i]);
								%>
									<tr>
										<td width=3% align="center">
											<%=i+1%>
											<input type="hidden" name="car_mng_id" value="<%=params[i]%>">
											<input type="hidden" name="car_end_yn_cnt" value="<%=ch_r.length%>">
										</td> <!-- 연번 -->
										<%	
									if(ch_r.length > 0){
						        		for(int j=0; j<1; j++){
						        			ch_bean = ch_r[j];
						        			String content_code = "CAR_CHANGE";
						    				String content_seq  = ch_bean.getCar_mng_id()+""+ch_bean.getCha_seq();
						    				
						    				Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
						    				int attach_vt_size = attach_vt.size(); %>
										<%  if(attach_vt_size > 0){%>
								    	<%		for (int k = 0 ; k < attach_vt_size ; k++){
				    								Hashtable attach_ht = (Hashtable)attach_vt.elementAt(k);    								
					    						%>
													<td width=15% align="center">
					    							&nbsp;<a href="javascript:openPopP('<%=attach_ht.get("FILE_TYPE")%>','<%=attach_ht.get("SEQ")%>');" title='보기' ><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>    							
					    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=attach_ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>    						
													</td><!-- 등록증 스캔 -->
										<%		}%>
				    						<%}else{%>
					    						<td width=15% align="center">
					    							<a href="javascript:scan_reg('<%=ch_bean.getCar_mng_id()%>','<%=ch_bean.getCha_seq()%>','<%=ht.get("CAR_NO")%>')"><img src=../images/center/button_in_reg.gif align=absmiddle border=0></a>
					    						</td>
				    						<%}%>
								<%		}%>
								<%	}else{ %>
										<td width=15% align="center">
			    							<%-- <a href="javascript:scan_reg('<%=ch_bean.getCar_mng_id()%>','<%=ch_bean.getCha_seq()%>')"><img src=../images/center/button_in_reg.gif align=absmiddle border=0></a> --%>
			    							수정시 등록버튼 생성
			    						</td>
								<%	}%>
										<td width=8% align="center"><%=ht.get("CAR_NO")%></a></td><!-- 차량번호 -->
										<td width=16% align="center"><span
											title="<%=ht.get("CAR_NM")%> <%=ht.get("CAR_NAME")%>"><%= Util.subData(ht.get("CAR_NM")+" "+ht.get("CAR_NAME"),25) %></span></td><!-- 차명 -->										
										<td width=17% align="center">
											<div style="float: left; margin-top: 3px;">&nbsp; <%=ht.get("CAR_END_DT")%> &nbsp;▶</div>  
											<div style="position: relative;"><input type="text" name="car_end_dt" value="<%=new_car_end_dt%>" size="10" style="text-align: center;"></div>
										</td><!-- 차령만료일 -->
										<td width=8% align="right" style="padding-right: 10px;"><%=ht.get("CAR_END_YN")%> ( <%=ch_r.length%>회 )</td><!-- 차량연장여부 -->
										<td width=8% align="center"><%=ht.get("CAR_DOC_NO")%></td><!-- 관리번호 -->
						
									<td align="center">
								<% 	if(ht.get("CHA_DT")!=null && !ht.get("CHA_DT").equals("")){%>	
										<%=ht.get("CHA_DT")%>
										<input type="hidden" id="cha_dt_<%=i%>" value="<%=ht.get("CHA_DT")%>">
								<% 	}else{%>
										<input type="hidden" id="cha_dt_<%=i%>" value=""/>
								<% 	}%>		
										<input type="hidden" name="data" id="data_<%=i%>" value="<%=params[i]%>//<%=ht.get("CHA_SEQ")%>//">
									</td>
								</tr>
							<%	}%>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>