<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, tax.*, acar.fee.*, acar.user_mng.* "%>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>

<%@ include file="/tax/cookies_base.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	out.println("세금계산서 발행하기 1단계"+"<br><br>");
	
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))		br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "06", "09");
	
	String reg_st 		= request.getParameter("reg_st")==null?"":request.getParameter("reg_st");//all-전체발행,select선택발행
	String reg_gu 		= request.getParameter("reg_gu")==null?"":request.getParameter("reg_gu");//1-일괄발행,2-통합발행,3-개별발행
	String mail_auto_yn = request.getParameter("mail_auto_yn")==null?"":request.getParameter("mail_auto_yn");//이메일발송방식
	String today 			= AddUtil.getDate(4);
	
	//사용자
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	
	String vid1[] 		= request.getParameterValues("h_l_cd");
	String vid2[] 		= request.getParameterValues("ch_l_cd");
	
	String vid_num		= "";
	String item_id		= "";
	int vid_size 			= 0;
	int flag 					= 0;
	int notreg 				= 0;


	if(reg_st.equals("all")){
		vid_size = vid1.length;
	}else{
		vid_size = vid2.length;
	}
	
	out.println("선택건수="+vid_size+"<br><br>");


	String tax_code  = Long.toString(System.currentTimeMillis());
	out.println("실행코드="+tax_code+"<br><br><br>");




	//[1단계] 거래명세서 처리코드 등록

	for(int i=0;i < vid_size;i++){
		if(reg_st.equals("all")){
			item_id = vid1[i];
		}else{
			item_id = vid2[i];
		}
		
		//거래명세서 조회
		TaxItemBean ti_bean 	= IssueDb.getTaxItemCase(item_id);
		
		//세금계산서일자가 오늘보다 크면 처리안함.
		if(AddUtil.parseInt(ti_bean.getTax_est_dt()) > AddUtil.parseInt(today)){
			 notreg++;
			 System.out.println(item_id+":세금계산서일자가 오늘보다 크면 처리안함");
				
			 continue;
		}else{
			
			//다음달10일이 수정기한
			String modify_deadline = AddUtil.replace(c_db.addMonth(AddUtil.ChangeDate2(ti_bean.getTax_est_dt()), 1),"-","").substring(0,6)+"10";
			
			modify_deadline = AddUtil.replace(af_db.getValidDt(modify_deadline),"-","");
			
			if(modify_deadline.equals("20171010")) modify_deadline = "20171013";
			
			//수정기한보다 오늘날짜가 클 경우 제외
			if(AddUtil.parseInt(modify_deadline) < AddUtil.parseInt(today)){
				notreg++;
				System.out.println(item_id+":수정기한보다 오늘날짜가 클 경우 제외");
			}else{
				//계약해지되어 미청구인 대여료 스케줄이 있으면 계산서를 발행하지 않는다.
				int scd_bill_yn = IssueDb.getTaxMakeCheck4(item_id);
				
				scd_bill_yn = 0;
				
				if(scd_bill_yn>0){
					notreg++;
				}else{
					ti_bean.setTax_code(tax_code);
					if(!IssueDb.updateTaxItem(ti_bean)) flag += 1;
					
//					System.out.println(tax_code+":대여료정기발행 tax_code");
				}
				
			}
		}
	}
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		fm.action = 'https://fms3.amazoncar.co.kr/acar/admin/call_sp_tax_ebill.jsp';		
		fm.submit();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body onLoad="javascript:init()">
<form name='form1' action='' method='post'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='reg_st' 		value='<%=reg_st%>'>
<input type='hidden' name='reg_gu' 		value='<%=reg_gu%>'>
<input type='hidden' name='tax_code' 	value='<%=tax_code%>'>
<input type='hidden' name='mail_auto_yn' value='<%=mail_auto_yn%>'>
<input type='hidden' name='sender_nm' 	value='<%=sender_bean.getSa_code()%>'>
</form>
<!--<a href="javascript:go_step()">2단계로 가기</a>-->
<script language='javascript'>
<!--
<%	if(flag > 0){//에러발생
		//이미 작성한 거래명서세 리스트 삭제
		if(!IssueDb.CancelTaxCode(tax_code)) flag += 1;%>
		alert("거래명세서 리스트 작성중 에러가 발생하였습니다.");
<%	}else{//정상%>

		<%if(notreg > 0){%>
			alert('세금계산서일자가 오늘보다 커 발행되지 않거나 교부기한을 경과하거나 해지된 계약이 <%=notreg%>건 있습니다');
		<%}%>

		<%if(notreg < vid_size){%>
		go_step();
		<%}%>
		
<%	}%>
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
