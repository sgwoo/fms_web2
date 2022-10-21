<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.common.*" %>
<jsp:useBean id="f_bean" class="acar.forfeit_mng.FineBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function UpdateList(car_mng_id,rent_mng_id,rent_l_cd,seq_no,fine_st,call_nm,tel,fax,vio_dt,vio_pla,vio_cont,paid_st,rec_dt,paid_end_dt,paid_amt,proxy_dt,pol_sta,paid_no,fault_st,fault_nm,dem_dt,coll_dt,rec_plan_dt,note,no_paid_yn,no_paid_cau,update_id,update_dt,obj_dt1,obj_dt2,obj_dt3,bill_doc_yn,bill_mon,vat_yn,tax_yn,f_dem_dt,e_dem_dt,busi_st){
		var fm = parent.parent.c_body.document.form1; 
		parent.parent.c_body.ClearM();
		fm.c_id.value = car_mng_id;
		fm.m_id.value = rent_mng_id;
		fm.l_cd.value = rent_l_cd;
		fm.seq_no.value = seq_no;
		if(fine_st == '1')	fm.fine_st[0].selected = true;
		if(fine_st == '2')	fm.fine_st[1].selected = true;		
		fm.call_nm.value = call_nm;
		fm.tel.value = tel;
		fm.fax.value = fax;
		fm.vio_dt.value = vio_dt;
		fm.vio_ymd.value = ChangeDate3(vio_dt.substring(0,8));
		fm.vio_s.value = vio_dt.substring(8,10);
		fm.vio_m.value = vio_dt.substring(10,12);
		fm.vio_pla.value = vio_pla;
		fm.vio_cont.value = vio_cont;
		if(paid_st == '1')	fm.paid_st[0].selected = true;
		if(paid_st == '2')	fm.paid_st[1].selected = true;						
		if(paid_st == '4')	fm.paid_st[2].selected = true;						
		if(paid_st == '3')	fm.paid_st[3].selected = true;								
		fm.rec_dt.value = rec_dt;
		fm.paid_end_dt.value = paid_end_dt;
		fm.paid_amt.value = paid_amt;
		fm.proxy_dt.value = proxy_dt;
		fm.pol_sta.value = pol_sta;
		fm.paid_no.value = paid_no;
		if(fault_st == '1')	fm.fault_st[0].selected = true;
		if(fault_st == '2')	fm.fault_st[1].selected = true;				
		fm.fault_nm.value = fault_nm;
		fm.dem_dt.value = dem_dt;
		fm.coll_dt.value = coll_dt;
		fm.rec_plan_dt.value = rec_plan_dt;
		fm.cmd.value="up";
		fm.note.value = note;
		if(no_paid_yn == 'Y'){
			fm.no_paid_yn.checked = true;
		}
		fm.no_paid_cau.value = no_paid_cau;
		fm.update_id.value = update_id;
		fm.update_dt.value = update_dt;
		fm.obj_dt1.value = obj_dt1;
		fm.obj_dt2.value = obj_dt2;
		fm.obj_dt3.value = obj_dt3;
		if(bill_doc_yn == '0')	fm.bill_doc_yn[0].selected = true;
		if(bill_doc_yn == '1')	fm.bill_doc_yn[1].selected = true;
//		fm.bill_mon[toInt(bill_mon)].selected = true;
		if(vat_yn == '0')	fm.vat_yn[0].selected = true;
		if(vat_yn == '1')	fm.vat_yn[1].selected = true;
		if(tax_yn == '0')	fm.tax_yn[0].selected = true;
		if(tax_yn == '1')	fm.tax_yn[1].selected = true;
		fm.f_dem_dt.value = f_dem_dt;
		fm.e_dem_dt.value = e_dem_dt;
		if(busi_st == '1')	fm.busi_st[0].selected = true;
		if(busi_st == '2')	fm.busi_st[1].selected = true;
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
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"3":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	AddForfeitDatabase a_fdb = AddForfeitDatabase.getInstance();
	FineBean f_r [] = a_fdb.getForfeitDetailAll(c_id, m_id, l_cd);
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
			            		<td width=190 align="left">&nbsp;<span title="<%=f_bean.getVio_pla()%>"><a href="javascript:UpdateList('<%=f_bean.getCar_mng_id()%>','<%=f_bean.getRent_mng_id()%>','<%=f_bean.getRent_l_cd()%>','<%=f_bean.getSeq_no()%>','<%=f_bean.getFine_st()%>','<%=f_bean.getCall_nm()%>','<%=f_bean.getTel()%>','<%=f_bean.getFax()%>','<%=f_bean.getVio_dt()%>','<%=f_bean.getVio_pla()%>','<%=f_bean.getVio_cont()%>','<%=f_bean.getPaid_st()%>','<%=f_bean.getRec_dt()%>','<%=f_bean.getPaid_end_dt()%>','<%=Util.parseDecimal(f_bean.getPaid_amt())%>','<%=f_bean.getProxy_dt()%>','<%=f_bean.getPol_sta()%>','<%=f_bean.getPaid_no()%>','<%=f_bean.getFault_st()%>','<%=f_bean.getFault_nm()%>','<%=f_bean.getDem_dt()%>','<%=f_bean.getColl_dt()%>','<%=f_bean.getRec_plan_dt()%>','<%=Util.htmlR(f_bean.getNote())%>','<%=f_bean.getNo_paid_yn()%>','<%=f_bean.getNo_paid_cau()%>','<%=c_db.getNameById(f_bean.getUpdate_id(), "USER")%>','<%=f_bean.getUpdate_dt()%>','<%=f_bean.getObj_dt1()%>','<%=f_bean.getObj_dt2()%>','<%=f_bean.getObj_dt3()%>','<%=f_bean.getBill_doc_yn()%>','<%=f_bean.getBill_mon()%>','<%=f_bean.getVat_yn()%>','<%=f_bean.getTax_yn()%>','<%=f_bean.getF_dem_dt()%>','<%=f_bean.getE_dem_dt()%>','<%=f_bean.getBusi_st()%>')"><%=Util.subData(f_bean.getVio_pla(),14)%></a></span></td>
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