<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*, acar.user_mng.* "%>
<jsp:useBean id="cop_db" scope="page" class="acar.car_office.CarOffPreDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 			= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	String s_kd 			= request.getParameter("s_kd")		==null?"":request.getParameter("s_kd");
	String t_wd 			= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String sort 			= request.getParameter("sort")		==null?"":request.getParameter("sort");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")	==null?"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")	==null?"":request.getParameter("gubun5");
	String st_dt 			= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")	==null?"":request.getParameter("from_page");

	int sh_height 		= request.getParameter("sh_height")	==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	int count =0;
	
	
	MaMenuDatabase nm_db 	= MaMenuDatabase.getInstance();
	LoginBean login 				= LoginBean.getInstance();
	String dept_id = login.getDept_id(user_id);
	String sch_user_id = "";
	if(dept_id.equals("1000")){		sch_user_id = user_id;			}
	Vector vt = cop_db.getRegEcarChargerList(s_kd, t_wd, sort, gubun1, gubun2, gubun3, gubun4, gubun5, st_dt, end_dt, sch_user_id);
	int vt_size = vt.size();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style type="text/css">
.complete{	background-color: #FAF4C0;	}	
</style>
<script type="text/javascript" src="http://code.jquery.com/jquery-1.9.1.js"></script> 
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    	    
	}
	
	function init(){		
		setupEvents();
		setViewForm();
	}	
//-->

	//등록 팝업
	function go_insert_charger_pop(){
		var fm = document.form1;
		window.open("ecar_charg_pop.jsp", "charg_pop", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}
	
	//전체선택
	function checkAll(){
		if($("#check_all").prop("checked")){	$("input[name=chk_btn]").prop("checked",true);			}
		else{													$("input[name=chk_btn]").prop("checked",false);			}
	}
	
	//여러건 삭제
	function delete_charger(){
		var str = '';
		$("input[name='chk_btn']:checked").each(function(){	
			str += this.value.substr(0,13) +"//";
		});
		if(str==''){		alert("삭제할 건들을 선택해 주세요.");			return;		}
		if(confirm("체크된 건들이 일괄 삭제됩니다.\n\n삭제하시겠습니까?")){
			window.open("ecar_charg_a.jsp?mode=D&param="+str, "charg_pop", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
		}
	}
	
	//보조금신청서, 완료서류
	function update_charger_doc(){
		var str = '';
		$("input[name='chk_btn']:checked").each(function(){
			str += this.value.substr(0,13) +","+
					   $("#subsi_form_yn_"+this.value.substr(14,15)+" option:selected").val()+","+
					   $("#doc_yn_"+this.value.substr(14,15)+" option:selected").val()+",//";
		});
		if(str==''){		alert("수정할 건들을 선택해 주세요.");			return;		}
		if(confirm("체크된 건들이 일괄 수정됩니다.\n\n수정하시겠습니까?")){
			window.open("ecar_charg_a.jsp?mode=U_ALL&param="+str, "charg_pop", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
		}
	}
	
	//보조금 신청서 색변경
	function change_subsi_color(num){
		$("#subsi_form_yn_"+num).css("color","red");
	}
	
	//완료서류 색변경
	function change_doc_color(num){
		$("#doc_yn_"+num).css("color","red");
	}
	
	//상세화면팝업
	function go_detail_pop(l_cd, m_id){
		var fm = document.form1;
		window.open("ecar_charg_pop.jsp?rent_l_cd="+l_cd+"&rent_mng_id="+m_id+"&mode=U", "charg_pop", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}
	
</script>
</head>
<body onLoad="javascript:init()">
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
	<tr>
		<td width="10%"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>총 <input type='text' name='size' value='<%=vt_size%>' size='4' class=whitenum> 건</span></td>
		<td width="*" align="right">(&nbsp;<span class='complete' style="border: 1px solid #B2CCFF;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> : 진행상태-완료)</td>
		<td width="20%" align="right">
			<button class='button' onclick='javascript:go_insert_charger_pop();'>등록</button>
			<%if(ck_acar_id.equals("000144") || nm_db.getWorkAuthUser("전산팀",ck_acar_id)){ %>
			<button class='button' onclick="javascript:update_charger_doc();">일괄수정</button>
			<button class='button' onclick="javascript:delete_charger();">일괄삭제</button>
			<%} %>
		</td>
	</tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>		
        <td class='line' id='td_title' style='position:relative;'> 
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
    	    	<colgroup>
    	    		<col width="2%">
    	    		<col width="3%">
    	    		<col width="8%">
    	    		<col width="*">
    	    		<col width="6%">
    	    		<col width="4%">
    	    		<col width="5%">
    	    		<col width="11%">
    	    		<col width="13%">
    	    		<col width="5%">
    	    		<col width="5%">
    	    		<col width="5%">
    	    		<col width="4%">
    	    		<col width="6%">
    	    		<col width="5%">
    	    		<col width="4%">
    	    	</colgroup>
                <tr>
                	<td class='title'><input type='checkbox' onclick="javascript:checkAll();" id='check_all'></td> 
                    <td class='title'>연번</td>
                    <td class='title'>계약번호</td>
                    <td class='title'>고객</td>
                    <td class='title'>등록일</td>
                    <td class='title'>담당자</td>
                    <td class='title'>차량번호</td>
	        	    <td class='title'>차대번호</td>
	        	    <td class='title'>차명</td>		  
	        	    <td class='title'>충전기타입</td>		  
	        	    <td class='title'>설치업체</td>
	        	    <td class='title'>고객자부담</td>
	        	    <td class='title'>소유권</td>
	              	<td class='title'>보조금<br>신청서</td>
	        	    <td class='title'>완료서류</td>
	        	    <td class='title'>진행상태</td>
        		</tr>
		    	<%if(vt_size > 0){%>
			    	<%	for(int i = 0 ; i < vt_size ; i++){
    							Hashtable ht = (Hashtable)vt.elementAt(i);
    							String add_class = "";
    							if(String.valueOf(ht.get("STAT")).equals("완료")){		add_class = "complete";		}
    				%>
	                <tr> 
	                	<td align='center' class="<%=add_class%>"><input type='checkbox' name="chk_btn" value="<%=ht.get("RENT_L_CD")%>,<%=i+1%>"></td>
	                    <td align='center' class="<%=add_class%>"><%=i+1%></td>
	                    <td align='center' class="<%=add_class%>"><a href="javascript:go_detail_pop('<%=ht.get("RENT_L_CD")%>','<%=ht.get("RENT_MNG_ID")%>');"><%=ht.get("RENT_L_CD")%></a></td>        	                        
	                    <td align='center' class="<%=add_class%>"><%=ht.get("FIRM_NM")%></td>
	                    <td align='center' class="<%=add_class%>"><%=String.valueOf(ht.get("REG_DT")).substring(0,10)%></td>
	                    <td align='center' class="<%=add_class%>"><%=ht.get("ACAR_NM")%></td>
	                    <td align='center' class="<%=add_class%>"><%=ht.get("CAR_NO")%></td>
	                    <td align='center' class="<%=add_class%>"><%=ht.get("CAR_NUM")%></td>
	                    <td align='center' class="<%=add_class%>"><%=ht.get("CAR_NM")%></td>
	                    <td align='center' class="<%=add_class%>"><%if(String.valueOf(ht.get("CHG_TYPE")).equals("1")){%>이동형<%}else if(String.valueOf(ht.get("CHG_TYPE")).equals("2")){%>고정형<%}%></td>
	                    <td align='center' class="<%=add_class%>">
	                    	<%if(String.valueOf(ht.get("INST_OFF")).equals("1")){%>파워큐브
	                    	<%}else if(String.valueOf(ht.get("INST_OFF")).equals("2")){ %>매니지온(이볼트)
	                    	<%}else if(String.valueOf(ht.get("INST_OFF")).equals("11")){ %>대영채비
	                    	<%}else if(String.valueOf(ht.get("INST_OFF")).equals("91")||String.valueOf(ht.get("INST_OFF")).equals("92")){ %>기타(<%=ht.get("ETC_INST_OFF")%>)
	                    	<%}else{%>
	                    	<%}%>	
	                    </td>
	                    <td align='center' class="<%=add_class%>"><%if(String.valueOf(ht.get("PAY_WAY")).equals("1")){%>고객납부<%}else if(String.valueOf(ht.get("PAY_WAY")).equals("2")){ %>견적반영<%} %></td>
	                    <td align='center' class="<%=add_class%>"><%if(String.valueOf(ht.get("CHG_PROP")).equals("1")){%>본인<%}else if(String.valueOf(ht.get("CHG_PROP")).equals("2")){ %>타인<%} %></td>
	                    <td align='center' class="<%=add_class%>">
	                    	<select class='select subsi_form_yn <%=add_class%>' name='subsi_form_yn' id="subsi_form_yn_<%=i+1%>" onchange="javascript:change_subsi_color('<%=i+1%>');">
	                    		<option value="N" <%if(!String.valueOf(ht.get("SUBSI_FORM_YN")).equals("Y")){%>selected<%}%>>미신청</option>
	                    		<option value="Y"<%if(String.valueOf(ht.get("SUBSI_FORM_YN")).equals("Y")){%>selected<%}%>>신청완료</option>
	                    	</select>
	                    </td>
	                    <td align='center' class="<%=add_class%>">
	                    	<select class='select doc_yn <%=add_class%>' name='doc_yn' id="doc_yn_<%=i+1%>" onchange="javascript:change_doc_color('<%=i+1%>');">
	                    		<option value="N" <%if(!String.valueOf(ht.get("DOC_YN")).equals("Y")){%>selected<%}%>>미처리</option>
	                    		<option value="Y"<%if(String.valueOf(ht.get("DOC_YN")).equals("Y")){%>selected<%}%>>처리완료</option>
	                    	</select>
	                    </td>
	                    <td align="center" class="<%=add_class%>"><%=ht.get("STAT")%></td>
	                </tr>
	        		<%	}	%>
			<%}else{%>
    			<tr>
                    <td align='center' colspan="16">등록된 데이타가 없습니다</td>
               </tr> 
			<%}	%>
		</table>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>

