<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.common.*" %>
<jsp:useBean id="f_bean" class="acar.forfeit_mng.FineBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>


<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function UpdateList(car_mng_id,rent_mng_id,rent_l_cd,seq_no,fine_st,call_nm,tel,fax,vio_dt,vio_pla,vio_cont,paid_st,rec_dt,paid_end_dt,paid_amt,proxy_dt,pol_sta,paid_no,fault_st,dem_dt,coll_dt,rec_plan_dt,note,no_paid_yn,no_paid_cau,update_id,update_dt){
		var theForm = parent.parent.c_body.document.ForfeitForm; 
		parent.parent.c_body.ClearM();
		theForm.car_mng_id.value = car_mng_id;
		theForm.rent_mng_id.value = rent_mng_id;
		theForm.rent_l_cd.value = rent_l_cd;
		theForm.seq_no.value = seq_no;
		theForm.fine_st.value = fine_st;
		theForm.call_nm.value = call_nm;
		theForm.tel.value = tel;
		theForm.fax.value = fax;
		theForm.vio_dt.value = vio_dt;
		theForm.vio_ymd.value = vio_dt.substring(0,8);
		theForm.vio_s.value = vio_dt.substring(8,10);
		theForm.vio_m.value = vio_dt.substring(10,12);
		theForm.vio_pla.value = vio_pla;
		theForm.vio_cont.value = vio_cont;
		theForm.paid_st.value = paid_st;
		theForm.rec_dt.value = rec_dt;
		theForm.paid_end_dt.value = paid_end_dt;
		theForm.paid_amt.value = paid_amt;
		theForm.proxy_dt.value = proxy_dt;
		theForm.pol_sta.value = pol_sta;
		theForm.paid_no.value = paid_no;
		theForm.fault_st.value = fault_st;
		theForm.dem_dt.value = dem_dt;
		theForm.coll_dt.value = coll_dt;
		theForm.rec_plan_dt.value = rec_plan_dt;
		theForm.cmd.value="up";
		theForm.note.value = note;
		if(no_paid_yn == 'Y'){
			theForm.no_paid_yn.checked = true;
		}
		theForm.no_paid_cau.value = no_paid_cau;
		theForm.update_id.value = update_id;		
		theForm.update_dt.value = update_dt;		
		//theForm.submit();
	}

	function FineCallReg(){
		var theForm1 = document.FineCallForm;
		var theForm2 = parent.c_body.document.ForfeitForm;	
		theForm1.car_mng_id.value = theForm2.car_mng_id.value;
		theForm1.car_no.value = theForm2.car_no.value;
		theForm1.rent_mng_id.value = theForm2.rent_mng_id.value;
		alert(theForm2.rent_mng_id.value);
		theForm1.rent_l_cd.value = theForm2.rent_l_cd.value;
		theForm1.call_dt.value = theForm1.call_dt_yr.value + theForm1.call_dt_mth.value + theForm1.call_dt_day.value;			
		theForm1.target="nodisplay";
		theForm1.submit();
	}

	/* Title 고정 */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	function moveTitle(){
    var X ;
    document.all.title.style.pixelTop = document.body.scrollTop ;                                                                            
    document.all.title_col0.style.pixelLeft	= document.body.scrollLeft ; 
    document.all.D1_col.style.pixelLeft	= document.body.scrollLeft ;      
	}
	function init(){	
		setupEvents();
	}
//-->
</script>
</head>
<body onLoad="javascript:init()">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String st = request.getParameter("st")==null?"2":request.getParameter("st");
	String f_st = request.getParameter("f_st")==null?"1":request.getParameter("f_st");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String call_dt = request.getParameter("call_dt")==null?"":request.getParameter("call_dt");
	String call_cont = request.getParameter("call_cont")==null?"":request.getParameter("call_cont");
	String reg_nm = request.getParameter("reg_nm")==null?"":request.getParameter("reg_nm");
	String call_dt_yr = "";
	String call_dt_mth = "";
	String call_dt_day = "";
	String user_id = "";
	String user_nm = "";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	LoginBean login = LoginBean.getInstance();
	user_id = login.getCookieValue(request, "acar_id");
	user_nm = login.getAcarName(user_id);
	
	AddForfeitDatabase a_fdb = AddForfeitDatabase.getInstance();
	FineBean f_r [] = a_fdb.getForfeitDetailAll(car_mng_id, rent_mng_id, rent_l_cd);
%>
<table border=0 cellspacing=0 cellpadding=0 width=1300>
    <tr>
        <td>
            <table border=0 cellspacing=0 cellpadding=0 width="1200">
            	<tr id='title' style='position:relative;z-index:1'>
            		<td class=line id='title_col0' style='position:relative;'>
            			<table border=0 cellspacing=1 width="400">
            				<tr>
								<td width=140 class=title>위반일자</td>
			            		<td width=70 class=title>과실여부</td>
			            		<td width=190 class=title>위반장소</td>
			            	</tr>
			            </table>
			        </td>
			        <td class=line>
			        	<table  border=0 cellspacing=1 width="900">
			        		<tr>
			        			<td width=190 class=title>위반내용</td>
			            		<td width=230 class=title>고지서번호</td>
			            		<td width=80 class=title>납부구분</td>
			            		<td width=80 class=title>영수일자</td>
			            		<td width=80 class=title>납부기한</td>
			            		<td width=80 class=title>대납일자</td>
			            		<td width=80 class=title>수금일자</td>
			            		<td width=80 class=title>납부금액</td>
			            	</tr>
			            </table>
			        </td>
				</tr>
            	<tr>
            		<td class=line id='D1_col' style='position:relative;'>
            			<table border=0 cellspacing=1>
<%	for(int i=0; i<f_r.length; i++){
    	f_bean = f_r[i];%>
            				<tr>
								<td width=140 align="center"><%=f_bean.getVio_dt_view()%></td>
			            		<td width=70 align="center"><%=f_bean.getFault_st_nm()%></td>
			            		<td width=190 align="left">&nbsp;<span title="<%=f_bean.getVio_pla()%>"><a href="javascript:UpdateList('<%=f_bean.getCar_mng_id()%>','<%=f_bean.getRent_mng_id()%>','<%=f_bean.getRent_l_cd()%>','<%=f_bean.getSeq_no()%>','<%=f_bean.getFine_st()%>','<%=f_bean.getCall_nm()%>','<%=f_bean.getTel()%>','<%=f_bean.getFax()%>','<%=f_bean.getVio_dt()%>','<%=f_bean.getVio_pla()%>','<%=f_bean.getVio_cont()%>','<%=f_bean.getPaid_st()%>','<%=f_bean.getRec_dt()%>','<%=f_bean.getPaid_end_dt()%>','<%=Util.parseDecimal(f_bean.getPaid_amt())%>','<%=f_bean.getProxy_dt()%>','<%=f_bean.getPol_sta()%>','<%=f_bean.getPaid_no()%>','<%=f_bean.getFault_st()%>','<%=f_bean.getDem_dt()%>','<%=f_bean.getColl_dt()%>','<%=f_bean.getRec_plan_dt()%>','<%=Util.htmlR(f_bean.getNote())%>','<%=Util.htmlR(f_bean.getNo_paid_yn())%>','<%=Util.htmlR(f_bean.getNo_paid_cau())%>','<%=c_db.getNameById(f_bean.getUpdate_id(), "USER")%>','<%=Util.htmlR(f_bean.getUpdate_dt())%>')"><%=Util.subData(f_bean.getVio_pla(),14)%></a></span></td>
            				</tr>
<%	}
	if(f_r.length == 0){ %>
		    		        <tr>
		            		    <td width=400 align=center height=25 colspan="3">&nbsp;</td>
			    	        </tr>
<%	}%>
			            </table>
			        </td>            		            		
            		<td class=line>
            			<table border=0 cellspacing=1>
<%	for(int i=0; i<f_r.length; i++){
    	f_bean = f_r[i];%>
							<tr>
								<td width=190 align="left"><span title="<%=f_bean.getVio_cont()%>"><%=Util.subData(f_bean.getVio_cont(),14)%></span></td>
			            		<td width=230 align="left">&nbsp;<%=f_bean.getPaid_no()%></td>
			            		<td width=80 align="center"><%=f_bean.getPaid_st_nm()%></td>
			            		<td width=80 align="center"><%=f_bean.getRec_dt()%></td>
			            		<td width=80 align="center"><%=f_bean.getPaid_end_dt()%></td>
			            		<td width=80 align="center"><%=f_bean.getProxy_dt()%></td>
			            		<td width=80 align="center"><%=f_bean.getColl_dt()%></td>
			            		<td width=80 align="right"><%=Util.parseDecimal(f_bean.getPaid_amt())%> 원</td>
            				</tr>
<%	}
	if(f_r.length == 0){ %>
				            <tr>
				                <td width=900 align=left height=25 colspan="8">&nbsp;&nbsp;등록된 데이타가 없습니다.</td>
	        			    </tr>
<%	}%>
			            </table>
			        </td>            		            		
            	</tr>

            </table>
        </td>
    </tr>
</table>	
</body>
</html>