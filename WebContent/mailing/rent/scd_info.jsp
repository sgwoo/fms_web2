<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.io.*, acar.cont.*, acar.fee.*, acar.util.*, acar.common.*, tax.*, acar.user_mng.*, acar.cls.*"%>
<jsp:useBean id="a_db" scope="session" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>

<%
	String m_id 	= request.getParameter("m_id")==null?"002316":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"S105YNCL00040":request.getParameter("l_cd");
	String rent_st 	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	
	String b_dt 	= request.getParameter("b_dt")==null?"":request.getParameter("b_dt");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String bill_yn 	= request.getParameter("bill_yn")==null?"":request.getParameter("bill_yn");
	String cls_chk 	= request.getParameter("cls_chk")==null?"N":request.getParameter("cls_chk");
	String reg_id 	= request.getParameter("reg_id")==null?"":request.getParameter("reg_id");	
	
	String rst = request.getParameter("rst")==null?"all":request.getParameter("rst");
	String rst_full_size = request.getParameter("fee_count")==null?"1":request.getParameter("fee_count");
	
	String excel_down_link = "https://fms1.amazoncar.co.kr/mailing/rent/scd_info_excel.jsp?m_id="+m_id+"&l_cd="+l_cd+"&rent_st="+rent_st+"&b_dt="+b_dt+"&mode="+mode+"&bill_yn="+bill_yn+"&cls_chk="+cls_chk+"&rst="+rst+"&rst_full_size="+rst_full_size;
	String excel_down_link2 = "https://fms1.amazoncar.co.kr/mailing/rent/scd_info_sn_excel.jsp?m_id="+m_id+"&l_cd="+l_cd+"&rent_st="+rent_st+"&b_dt="+b_dt+"&mode="+mode+"&bill_yn="+bill_yn+"&cls_chk="+cls_chk+"&rst="+rst+"&rst_full_size="+rst_full_size;
	
	String stamp_yn 	= request.getParameter("stamp_yn")==null?"N":request.getParameter("stamp_yn");
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//cont_view
	Hashtable base = a_db.getContViewCase(m_id, l_cd);
	//자동이체정보
	ContCmsBean cms = a_db.getCmsMng(m_id, l_cd);
	//대여갯수 카운터
	int fee_count = af_db.getFeeCount(l_cd);
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(m_id, l_cd)+"";
	}
	
	//출고전대차 조회
	ContTaechaBean taecha = a_db.getContTaechaCase(m_id, l_cd, taecha_no);
	
	//대여기본정보
	ContFeeBean fee = a_db.getContFee(m_id, l_cd, rent_st);
	
	int tae_sum = af_db.getTaeCnt(m_id);
	
	//건별 대여료 스케줄 리스트
	Vector fee_scd = af_db.getFeeScdNew3(m_id, l_cd, b_dt, mode, bill_yn, rst, false);		// 2018.04.24
	int fee_scd_size = fee_scd.size();

	Vector fee_scd_sun_nap = af_db.getFeeScdNew3(m_id, l_cd, b_dt, mode, bill_yn, rst, true);		// 2018.04.24
	int fee_scd_sun_nap_size = fee_scd_sun_nap.size();
	
	//건별 대여료 스케줄 통계
	//계약관리 - 대여료 - 대여료스케줄안내문 팝업에서 연장 구분으로 선택하여 미리보기 할 경우 
	//장기대여 스케줄 안내문 하단 대여료 통계의 연체료가 해당하는 연장 건에만 출력되도록 한다 2018.04.24
	Hashtable fee_stat = af_db.getFeeScdStatNew2(m_id, l_cd, b_dt, mode, bill_yn, rst);	// 2018.04.24
	int fee_stat_size = fee_stat.size();
	
	//해지정보
	ClsBean cls = as_db.getClsCase(m_id, l_cd);
	
	int nc = 0;
	int ns = 0;
	int nv = 0;
	int rc = 0;
	int rs = 0;
	int rv = 0;
	int mc = 0;
	int ms = 0;
	int mv = 0;
	int dc = 0;
	int dt = 0;
	int dt2 = 0;
	
	//담당자정보
	UserMngDatabase u_db = UserMngDatabase.getInstance();
	//영업담당자
	UsersBean b_user = u_db.getUsersBean(String.valueOf(base.get("BUS_ID2")));
	//스케줄담당자
	UsersBean h_user = u_db.getUsersBean(nm_db.getWorkAuthUser("세금계산서담당자"));
	
	//계좌번호 *로 가리기
	int acc_len = cms.getCms_acc_no().length();
	String acc_no = "";
	String acc_no1 = "";
	String acc_no2 = "";
	if(acc_len > 0){
		if(cms.getCms_acc_no().lastIndexOf("-") == -1){
			acc_no1 = "*******";
			if(acc_len > 7){
				acc_no2 = cms.getCms_acc_no().substring(7,acc_len);
			}
			acc_no = acc_no1+acc_no2;
		}else{
			acc_no1 = cms.getCms_acc_no().substring(0,cms.getCms_acc_no().lastIndexOf("-"));
			acc_no2 = cms.getCms_acc_no().substring(cms.getCms_acc_no().lastIndexOf("-"));
    		for (int i = 0; i < acc_no1.length(); i++){
	    		char c = (char) acc_no1.charAt(i);
    			if ( c == '-') 
    				acc_no += "-";
    			else 
	    			acc_no += "*";
    		}
			acc_no += acc_no+acc_no2;
		}
	}
	
	//차량 뒷번호 가리기
	int car_no_len = String.valueOf(base.get("CAR_NO")).length();
	String car_no = "";
	if(car_no_len > 3){
		car_no = String.valueOf(base.get("CAR_NO")).substring(0,car_no_len-2)+"**";
	}
%>


<html>
<head>
<meta http-equiv=Content-Type content=text/html; charset=euc-kr>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>아마존카 장기대여 이용안내문</title>
<link href=http://www.amazoncar.co.kr/style.css rel=stylesheet type=text/css>
<style type="text/css">
<!--
.style1 {color: #88b228;font-size:13px;}
.style2 {color: #333333;font-size:13px;}
.style3 {color: #ffffff}
.style4 {color: #707166; font-weight: bold;}
.style5 {color: #e86e1b}
.style6 {color: #385c9d; font-weight: bold;}
.style7 {color: #77786b}
.style8 {color: #e60011}
.style9 {color: #707166; font-weight: bold;}
.style10 {color: #454545; font-size:8pt;}
.style11 {color: #6b930f; font-size:8pt;}
.style12 {color: #77786b; font-size:8pt;}
.style14 {color: #af2f98; font-size:8pt;}
.style15 {color: #707166; font-weight: bold; font-size:8pt;}
-->
</style>

</head>
<body topmargin=0 leftmargin=0>
<table width=700 border=0 cellspacing=0 cellpadding=0 align=center>
    <tr>
        <td>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=22>&nbsp;</td>
                    <td width=558><a href=http://www.amazoncar.co.kr target=_blank onFocus=this.blur();><img src=https://fms5.amazoncar.co.kr/mailing/images/logo.gif width=332 height=52 border=0></a></td>
            		<!-- 고객 FMS로그인 버튼 -->
                    <td width=114 valign=baseline>&nbsp;<!--<a href=http://fms.amazoncar.co.kr/service/index.jsp target=_blank onFocus=this.blur();><img src=https://fms5.amazoncar.co.kr/mailing/images/button_fms_login.gif border=0></a>--></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=7></td>
    </tr>
    <tr>
        <td><img src=https://fms5.amazoncar.co.kr/mailing/images/layout_top.gif width=700 height=21></td>
    </tr>

    <tr>
        <td height=5 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=677 border=0 cellspacing=0 cellpadding=0 style="background:url(https://fms5.amazoncar.co.kr/mailing/images/img_top.gif) no-repeat;">
                <tr>
                    <td width=411 valign=top align=center>
                        <table width=411 border=0 cellspacing=0 cellpadding=0 align=center>
                        	<tr>
                        		<td height=20></td>
                        	</tr>
                            <tr>
                                <td height=50 align=left>&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/sinfo_title.gif></td>
                            </tr>
                       <!-- 업체명 -->
                            <tr>
                                <td height=30 align=left style="font-family:nanumgothic, Sans-serif;font-size:13px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/info_arrow.gif width=10 height=11> &nbsp;<span style="color:#88b228;"><b><%=base.get("FIRM_NM")%></b></span>&nbsp;님 귀하</td>
                            </tr>
                       <!-- 업체명 -->
                            <tr>
                                <td height=11></td>
                            </tr>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/info_line_up.gif width=410 height=3></td>
                            </tr>
                            <tr>
                                <td bgcolor=f7f7f7 align=center>
                                    <table width=400 border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td colspan=3 height=15></td>
                                        </tr>
                                        <tr>
                                            <td width=12>&nbsp;</td>
                                            <td width=386 align=left>
                                                <table width=386 border=0 cellspacing=0 cellpadding=0>
                                                    <tr>
                                                        <td height=18 style="font-family:nanumgothic, Sans-serif;font-size:13px;">최상의 서비스를 제공하는 장기렌트 전문 회사 (주)아마존카를 이용해 주셔서 감사합니다. 문의하신 대여료 스케줄 내역과 통계입니다.</td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width=12>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan=3 height=15></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/info_line_dw.gif width=410 height=3></td>
                            </tr>
                            <tr>
                                <td height=15></td>
                            </tr>
                        </table>
                    </td>
                    <td width=187 valign=top align=center>
            			<table width=187 border=0 cellpadding=0 cellspacing=0>
                            <tr>
                                <td width=187 height=233>
                                    <table width=187 border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td height=60 align=left></td>
                                        </tr>
                                        <tr>
                                            <td align=left>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/sup_1.gif width=70 height=20></td>
                                        </tr>
                                        <tr>
                                            <td height=2></td>
                                        </tr>
                              <!-- 담당자 전화번호 -->
                                        <tr>
                                            <td align=left height=17>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-family:nanumgothic, Sans-serif;font-size:11px;color:#FFFFFF;"><strong><%=h_user.getUser_nm()%></strong></span><!--[$user_h_tel$]--> </td>
                                        </tr>
                                        <tr>
                                            <td align=left height=17>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-family:nanumgothic, Sans-serif;font-size:11px;color:#FFFFFF;"><strong><%=h_user.getHot_tel()%></strong></span><!--[$user_h_tel$]--></td>
                                        </tr>
                                        <tr>
                                            <td height=12></td>
                                        </tr>
                                        <tr>
                                            <td align=left>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/sup_2.gif width=70 height=20></td>
                                        </tr>
                                        <tr>
                                            <td height=2></td>
                                        </tr>
                                        <tr>
                                            <td align=left height=17>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-family:nanumgothic, Sans-serif;font-size:11px;color:#FFFFFF;"><strong><%=b_user.getUser_nm()%></strong></span></td>
                                        </tr>
                                        <tr>
                                            <td align=left height=17>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-family:nanumgothic, Sans-serif;font-size:11px;color:#FFFFFF;"><strong><%=b_user.getUser_m_tel()%></strong></span></td>
                                        </tr>
                              <!-- 담당자 전화번호 -->
                                    </table>
                                </td>
                            </tr>
                        </table>
            		</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=30 align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=648 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/bar_1.gif width=648 height=21></td>
                </tr>
                <tr>
                    <td height=5></td>
                </tr>
                <%-- <%if(rst.equals("all") && Integer.parseInt(rst_full_size) > 1){
                		for(int r=0; r<Integer.parseInt(rst_full_size); r++){
                			ContFeeBean[] ext_fee2 = new ContFeeBean[Integer.parseInt(rst_full_size)];
                			ext_fee2[r] = a_db.getContFeeNew(m_id, l_cd, Integer.toString(r+1));
                %> --%>
                <%if(rst.equals("all") && fee_count > 1){
                		for(int r=0; r<fee_count; r++){
                			ContFeeBean[] ext_fee2 = new ContFeeBean[fee_count];
                			ext_fee2[r] = a_db.getContFeeNew(m_id, l_cd, Integer.toString(r+1));
                %>
                <tr><!-- 계약사항 : 대여료 - 이메일 - 대여료스케줄안내문 팝업에서 연장 구분을 전체로 선택 한 경우 2018.04.24 -->
                	<td style="font-family:nanumgothic, Sans-serif;font-size:13px;"><%if(r==0){%>신차대여<%}else{%><%=r%>차 대여<%}%></td>
                </tr>
                <tr>
                	<td>
                		<table width=648 border=0 cellpadding=0 cellspacing=1 bgcolor=cacaca>
                			<tr align="center">
                				<td height="24" width=225 bgcolor=f2f2f2 colspan=4 style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">대여차종</td>
                			</tr>
                			<tr bgcolor=#FFFFFF>
                        		<td height="24" align=center colspan=4><span style="color:#e86e1b;font-family:nanumgothic, Sans-serif;font-size:11px;"
                        			>&#91;<%=base.get("CAR_NO")%>&#93; <%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%></span></td>
                        	</tr>
                        	<tr align="center">
                    			<td height="24" width=148 bgcolor=f2f2f2 style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">월대여료(VAT별도)</td>
                				<td width=120 bgcolor=f2f2f2 style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">장기대여보증금</td>
                				<td width=120 bgcolor=f2f2f2 style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">선납금(VAT별도)</td>
                				<td width=150 bgcolor=f2f2f2 style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">개시대여료(VAT별도)</td>    	
                        	</tr>
                        	<tr bgcolor=#FFFFFF>
                        		<td height="24" align=center>
                        			<span style="color:#385c9d;font-weight:bold;font-family:nanumgothic, Sans-serif;font-size:11px;">
                        			<%-- <%= Util.parseDecimal(ext_fee2[r].getFee_s_amt()+ext_fee2[r].getFee_v_amt()) %>원 --%>
                        			<%=AddUtil.parseDecimal(ext_fee2[r].getFee_s_amt()) %>원
                        			</span>
                        		</td>
								<td align=center>
									<span style="color:#333333;font-family:nanumgothic, Sans-serif;font-size:11px;">
									<%=AddUtil.parseDecimal(ext_fee2[r].getGrt_amt_s())%>원
									</span>
								</td>
								<td align=center>
									<span style="color:#333333;font-family:nanumgothic, Sans-serif;font-size:11px;">
									<%-- <%=AddUtil.parseDecimal(ext_fee2[r].getPp_s_amt()+ext_fee2[r].getPp_v_amt())%>원 --%>
									<%=AddUtil.parseDecimal(ext_fee2[r].getPp_s_amt())%>원
									</span>
								</td>
								<td align=center>
									<span style="color:#333333;font-family:nanumgothic, Sans-serif;font-size:11px;">
									<%-- <%=AddUtil.parseDecimal(ext_fee2[r].getIfee_s_amt()+ext_fee2[r].getIfee_v_amt())%>원 --%>
									<%=AddUtil.parseDecimal(ext_fee2[r].getIfee_s_amt())%>원
									</span>
								</td>
                        	</tr>
                        	<tr align="center">
                				<td height="24" bgcolor=f2f2f2><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">대여기간</span></td>
                				<td bgcolor=f2f2f2><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">대여개시일</span></td>
                                <td bgcolor=f2f2f2><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">대여만료일</span></td>
                                <td bgcolor=f2f2f2><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">비고</span></td>
                			</tr>
                			<tr align=center bgcolor=#FFFFFF>
                				<td height="24"><span style="color:#333333;font-family:nanumgothic, Sans-serif;font-size:11px;"><%=ext_fee2[r].getCon_mon()%>개월</span></td>
                				<td><span style="color:#333333;font-family:nanumgothic, Sans-serif;font-size:11px;"><%=ext_fee2[r].getRent_start_dt()%></span></td>
                                <td><span style="color:#333333;font-family:nanumgothic, Sans-serif;font-size:11px;"><%=ext_fee2[r].getRent_end_dt()%></span></td>
                                <td><span style="color:#333333;font-family:nanumgothic, Sans-serif;font-size:11px;"></span></td>
                			</tr>
                		</table>
                	</td>
                </tr>
                <tr>
                    <td height=30></td>
                </tr>
                <%
                		}
                	}else{
                		ContFeeBean ext_fee = a_db.getContFeeNew(m_id, l_cd, rst);
                %>
                <tr>
                    <td>
              <!-- 계약사항 : 신차대여, 1차 연장, 2차 연장, 3차 연장 ... -->
                        <table width=648 border=0 cellpadding=0 cellspacing=1 bgcolor=cacaca>
                        	<tr align=center>
                        		<td height=24 width=225 bgcolor=f2f2f2 colspan=4 style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">대여차종</td>
                        	</tr>
                        	<tr bgcolor=#FFFFFF>
                        		<td height=35 align=center colspan=4><span style="color:#e86e1b;font-family:nanumgothic, Sans-serif;font-size:11px;"
                        			>&#91;<%=base.get("CAR_NO")%>&#93; <%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%></span></td>
                        	</tr>
                            <tr align=center>
                                <td height=24 width=148 bgcolor=f2f2f2 style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">월대여료(VAT별도)</td>
                                <td width=120 bgcolor=f2f2f2 style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">장기대여보증금</td>
                                <td width=120 bgcolor=f2f2f2 style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">선납금(VAT별도)</td>
                                <td width=150 bgcolor=f2f2f2 style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">개시대여료(VAT별도)</td>
                            </tr>
                            <tr bgcolor=#FFFFFF>
                                <td height=35 align=center>
                                	<span style="color:#385c9d;font-weight:bold;font-family:nanumgothic, Sans-serif;font-size:11px;">
                                	<%-- <%=Util.parseDecimal(ext_fee.getFee_s_amt()+ext_fee.getFee_v_amt())%>원 --%>
                                	<%=Util.parseDecimal(ext_fee.getFee_s_amt())%>원
                                	</span>
                                </td>
                                <td align=center>
                                	<span style="color:#333333;font-family:nanumgothic, Sans-serif;font-size:11px;">
                                	<%=AddUtil.parseDecimal(ext_fee.getGrt_amt_s())%>원
                                	</span>
                                </td>
                                <td align=center>
                                	<span style="color:#333333;font-family:nanumgothic, Sans-serif;font-size:11px;">
                                	<%-- <%=AddUtil.parseDecimal(ext_fee.getPp_s_amt()+ext_fee.getPp_v_amt())%>원 --%>
                                	<%=AddUtil.parseDecimal(ext_fee.getPp_s_amt())%>원
                                	</span>
                                </td>
                                <td align=center>
                                	<span style="color:#333333;font-family:nanumgothic, Sans-serif;font-size:11px;">
                                	<%-- <%=AddUtil.parseDecimal(ext_fee.getIfee_s_amt()+ext_fee.getIfee_v_amt())%>원 --%>
                                	<%=AddUtil.parseDecimal(ext_fee.getIfee_s_amt())%>원
                                	</span>
                                </td>
                            </tr>
                            <tr align=center>
                                <td height=24 bgcolor=f2f2f2><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">대여기간</span></td>
                                <td bgcolor=f2f2f2><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">대여개시일</span></td>
                                <td bgcolor=f2f2f2><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">대여만료일</span></td>
                                <td bgcolor=f2f2f2><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">비고</span></td>
                            </tr>
                            <tr align=center bgcolor=#FFFFFF>
                                <td height=35><span style="color:#333333;font-family:nanumgothic, Sans-serif;font-size:11px;"><%=ext_fee.getCon_mon()%>개월</span></td>
                                <td><span style="color:#333333;font-family:nanumgothic, Sans-serif;font-size:11px;"><%=ext_fee.getRent_start_dt()%></span></td>
                                <td><span style="color:#333333;font-family:nanumgothic, Sans-serif;font-size:11px;"><%=ext_fee.getRent_end_dt()%></span></td>
                                <td><span style="color:#333333;font-family:nanumgothic, Sans-serif;font-size:11px;"></span></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=30></td>
                </tr>
                <%} %>
                <tr>
                    <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/bar_2.gif width=648 height=21></td><!-- 대여료입금 안내 -->
                </tr>
                <tr>
                    <td height=5></td>
                </tr>
                <tr>
                    <td>
                        <table width=648 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/rent/images/con_bg.gif>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/con_up.gif width=648 height=7></td>
                            </tr>
                            <tr>
                                <td height=5></td>
                            </tr>
                            <tr>
                                <td height=25 style="font-family:nanumgothic, Sans-serif;font-size:13px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/arrow.gif> 
                                            <span style="color:#333333;font-family:nanumgothic, Sans-serif;">고객님의 대여료 납부일은 매월 <span style="color:red;font-family:nanumgothic, Sans-serif;"><b><%if(fee.getFee_est_day().equals("99")){%>말일<%}else{%><%= fee.getFee_est_day() %><%}%></b></span>일입니다.</span></td>
                        	</tr>
                 			<tr>
                                <td height=25 style="font-family:nanumgothic, Sans-serif;font-size:13px;" align=left>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/arrow.gif> 
                                <span style="color:#333333;font-family:nanumgothic, Sans-serif;">결제일 변경을 원하시는 경우 (주)아마존카 총무팀 <span style="color:#e86e1b;font-family:nanumgothic, Sans-serif;">(Tel.02-392-4243)</span>으로 요청해 주시기 바랍니다.<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(결제일 조정 등으로 대여료 일할계산 청구가 발생할 수 있습니다.)</span></td>
                            </tr>
                            <tr>
                                <td height=25 style="font-family:nanumgothic, Sans-serif;font-size:13px;" align=left>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/arrow.gif> 
                                <span style="color:#333333;font-family:nanumgothic, Sans-serif;">입금예정일자가 <span style="color:#e86e1b;font-family:nanumgothic, Sans-serif;">공휴일/주말</span>인 경우 <span style="color:#e86e1b;font-family:nanumgothic, Sans-serif;">익일</span>이 입금예정일자입니다.</span></td>
                            </tr>
                            <tr>
                                <td height=6></td>
                            </tr>
                            <tr>
                                <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/con_dw.gif width=648 height=7></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=30></td>
                </tr>
                <tr><!-- 대여료 스케줄 -->
                    <td>
                    	<img src=https://fms5.amazoncar.co.kr/mailing/rent/images/bar_3_1.gif width=600 height=21><!-- <a href="javascript:pop_excel('dyr');"> --><a href="<%=excel_down_link%>"><img src=https://fms5.amazoncar.co.kr/acar/images/center/button_excel.gif border=0></a>
                    </td>
                </tr>
                <tr>
                    <td height=5></td>
                </tr>
                <tr>
                    <td>
             		<!-- 대여료 스케줄 -->
                        <table width=648 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                            <tr bgcolor=f2f2f2>
                                <td width=20 height=32 align=center><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">회차</span></td>
                                <td width=135 align=center><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">사용기간</span></td>
                                <td width=70 align=center><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">입금예정<br>일자</span></td>
                                <td width=60 align=center><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">공급가</span></td>
                                <td width=50 align=center><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">부가세</span></td>
                                <td width=62 align=center><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">월대여료</span></td>
                                <td width=62 align=center><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">입금일자</span></td>
                                <td width=60 align=center><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">실입금액</span></td>
                                <td width=40 align=center><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">연체<br>일수</span></td>
                                <td width=50 align=center><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">연체료</span></td>
                                <td width=68 align=center><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">세금계산서<br>발행일자</span></td>
                            </tr>
                            <%-- <tr bgcolor=#FFFFFF>
                                <td colspan=11>
                                    <table width=646 border=0 cellspacing=0 cellpadding=0>
									<% 	if(fee_scd_size>0){
											for(int i = 0 ; i < fee_scd_size ; i++){
												FeeScdBean scd = (FeeScdBean)fee_scd.elementAt(i);
												if(cls_chk.equals("Y") && !scd.getTm_st1().equals("0") && scd.getBill_yn().equals("N")) continue;
												//대여료통계
												if(scd.getRc_amt()>0){//수금
													rc ++;
													rs += Math.round(scd.getRc_amt()/1.1);
													rv += scd.getRc_amt()-(Math.round(scd.getRc_amt()/1.1));
												}else{
													if(scd.getDly_fee()==0){//미도래
														mc ++;
														ms += scd.getFee_s_amt();
														mv += scd.getFee_v_amt();
													}else{
														nc ++;
														ns += scd.getFee_s_amt();
														nv += scd.getFee_v_amt();
													}
												}
												//연체료통계
												if(scd.getDly_fee()>0){
													dc ++;
													dt += scd.getDly_fee();
												}%>												
                                        <tr <%if(i%2 != 0){%>bgcolor=f7fae5<%}%>>
                                            <td width=21 height=23 align=center>
                                              <span style="color:#333333;font-family:nanumgothic, Sans-serif;font-size:11px;">
                                                <%if(scd.getTm_st2().equals("2")){%>b<%}%>
                                                <%=scd.getFee_tm()%>
                                              </span>
                                            </td><!-- 회차 -->
                                            <td width=136 align=center><span style="color:#333333;font-size:11px;font-family:nanumgothic, Sans-serif;">
											<%if(scd.getTm_st1().equals("0")){%>
											<%=AddUtil.ChangeDate2(scd.getUse_s_dt())%>~<%=AddUtil.ChangeDate2(scd.getUse_e_dt())%>
											<%}else{%>
											잔액
											<%}%>
											</span></td>
                                            <td width=71 align=center><span style="color:#6b930f;font-size:11px;font-family:nanumgothic, Sans-serif;"><%=AddUtil.ChangeDate2(scd.getFee_est_dt())%></span></td>
                                            <td width=61 align=right><span style="color:#333333;font-size:11px;font-family:nanumgothic, Sans-serif;"><%=Util.parseDecimal(scd.getFee_s_amt())%></span>&nbsp;</td>
                                            <td width=51 align=right><span style="color:#333333;font-size:11px;font-family:nanumgothic, Sans-serif;"><%=Util.parseDecimal(scd.getFee_v_amt())%></span>&nbsp;</td>
                                            <td width=76 align=right><span style="color:#6b930f;font-size:11px;font-family:nanumgothic, Sans-serif;"><b><%=Util.parseDecimal(scd.getFee_s_amt()+scd.getFee_v_amt())%></b> </span>&nbsp;</td>
											<%if(scd.getBill_yn().equals("Y")){%>
											<%		if( cls_chk.equals("Y") && scd.getRc_dt().equals(AddUtil.replace(cls.getCls_dt(),"-","")) ){%>
                                        	<td width=61 align=center><span style="color:#333333;font-size:11px;font-family:nanumgothic, Sans-serif;"></span></td>
                                        	<td width=76 align=right><span style="color:#6b930f;font-size:11px;font-family:nanumgothic, Sans-serif;"><b>0</b></span>&nbsp;</td>
											<%		}else{%>
                                        	<td width=61 align=center><span style="color:#333333;font-size:11px;font-family:nanumgothic, Sans-serif;"><%=AddUtil.ChangeDate2(scd.getRc_dt())%></span></td>
                                        	<td width=76 align=right><span style="color:#6b930f;font-size:11px;font-family:nanumgothic, Sans-serif;"><b><%=Util.parseDecimal(scd.getRc_amt())%></b></span>&nbsp;</td>
											<%		}%>
											<%}else{%>
                                        	<td width=61 align=center><span style="color:#333333;font-size:11px;font-family:nanumgothic, Sans-serif;"><%if(cls_chk.equals("Y")){%><%}else{%><%=AddUtil.replace(cls.getCls_dt(),"-","")%><%}%></span></td>
                                        	<td width=76 align=right><span style="color:#6b930f;font-size:11px;font-family:nanumgothic, Sans-serif;"><b><%if(cls_chk.equals("Y")){%>0원<%}else{%>중도해지정산<%}%></b></span>&nbsp;</td>
											<%}%>
                                        	<td width=41 align=center><span style="color:#333333;font-size:11px;font-family:nanumgothic, Sans-serif;"><%=scd.getDly_days()%>일</span></td>
                                        	<td width=52 align=right><span style="color:#333333;font-size:11px;font-family:nanumgothic, Sans-serif;"><%=Util.parseDecimal(scd.getDly_fee())%></span>&nbsp;</td>
                                        	<td width=60 align=center><span style="color:#333333;font-size:11px;font-family:nanumgothic, Sans-serif;"><%=AddUtil.ChangeDate2(scd.getExt_dt())%></span></td>
                                        </tr>
									<%}}%>	
                                    </table>
                                </td>
                            </tr> --%>
                            <% 	if(fee_scd_size>0){
										for(int i = 0 ; i < fee_scd_size ; i++){
											FeeScdBean scd = (FeeScdBean)fee_scd.elementAt(i);
											if(cls_chk.equals("Y") && !scd.getTm_st1().equals("0") && scd.getBill_yn().equals("N")) continue;
											//대여료통계
											if(scd.getRc_amt()>0){//수금
												rc ++;
												rs += Math.round(scd.getRc_amt()/1.1);
												rv += scd.getRc_amt()-(Math.round(scd.getRc_amt()/1.1));
											}else{
												if(scd.getDly_fee()==0){//미도래
													mc ++;
													ms += scd.getFee_s_amt();
													mv += scd.getFee_v_amt();
												}else{
													nc ++;
													ns += scd.getFee_s_amt();
													nv += scd.getFee_v_amt();
												}
											}
											//연체료통계
											if(scd.getDly_fee()>0){
												dc ++;
												dt += scd.getDly_fee();
											}%>												
	                                      <tr <%if(i%2 != 0){%>bgcolor=f7fae5<%}else{%>bgcolor=ffffff<%}%>>
	                                          <td height=23 align=center>
	                                            <span style="color:#333333;font-family:nanumgothic, Sans-serif;font-size:10px;">
	                                              <%if(scd.getTm_st2().equals("2")){%>b<%}%>
	                                              <%=scd.getFee_tm()%>
	                                            </span>
	                                          </td><!-- 회차 -->
	                                          <td align=center><span style="color:#333333;font-size:10px;font-family:nanumgothic, Sans-serif;">
										<%if(scd.getTm_st1().equals("0")){%>
										<%=AddUtil.ChangeDate2(scd.getUse_s_dt())%>~<%=AddUtil.ChangeDate2(scd.getUse_e_dt())%>
										<%}else{%>
										잔액
										<%}%>
										</span></td>
	                                          <td align=center><span style="color:#6b930f;font-size:10px;font-family:nanumgothic, Sans-serif;"><%=AddUtil.ChangeDate2(scd.getFee_est_dt())%></span></td>
	                                          <td align=right><span style="color:#333333;font-size:10px;font-family:nanumgothic, Sans-serif;"><%=Util.parseDecimal(scd.getFee_s_amt())%></span>&nbsp;</td>
	                                          <td align=right><span style="color:#333333;font-size:10px;font-family:nanumgothic, Sans-serif;"><%=Util.parseDecimal(scd.getFee_v_amt())%></span>&nbsp;</td>
	                                          <td align=right><span style="color:#6b930f;font-size:10px;font-family:nanumgothic, Sans-serif;"><b><%=Util.parseDecimal(scd.getFee_s_amt()+scd.getFee_v_amt())%></b> </span>&nbsp;</td>
										<%if(scd.getBill_yn().equals("Y")){%>
										<%		if( cls_chk.equals("Y") && scd.getRc_dt().equals(AddUtil.replace(cls.getCls_dt(),"-","")) ){%>
	                                      	<td align=center><span style="color:#333333;font-size:10px;font-family:nanumgothic, Sans-serif;"></span></td>
	                                      	<td align=right><span style="color:#6b930f;font-size:10px;font-family:nanumgothic, Sans-serif;"><b>0</b></span>&nbsp;</td>
										<%		}else{%>
	                                      	<td align=center><span style="color:#333333;font-size:10px;font-family:nanumgothic, Sans-serif;"><%=AddUtil.ChangeDate2(scd.getRc_dt())%></span></td>
	                                      	<td align=right><span style="color:#6b930f;font-size:10px;font-family:nanumgothic, Sans-serif;"><b><%=Util.parseDecimal(scd.getRc_amt())%></b></span>&nbsp;</td>
										<%		}%>
										<%}else{%>
	                                      	<td align=center><span style="color:#333333;font-size:10px;font-family:nanumgothic, Sans-serif;"><%if(cls_chk.equals("Y")){%><%}else{%><%=AddUtil.replace(cls.getCls_dt(),"-","")%><%}%></span></td>
	                                      	<td align=right><span style="color:#6b930f;font-size:10px;font-family:nanumgothic, Sans-serif;"><b><%if(cls_chk.equals("Y")){%>0원<%}else{%>중도해지정산<%}%></b></span>&nbsp;</td>
										<%}%>
	                                      	<td align=center><span style="color:#333333;font-size:10px;font-family:nanumgothic, Sans-serif;"><%=scd.getDly_days()%>일</span></td>
	                                      	<td align=right><span style="color:#333333;font-size:10px;font-family:nanumgothic, Sans-serif;"><%=Util.parseDecimal(scd.getDly_fee())%></span>&nbsp;</td>
	                                      	<td align=center><span style="color:#333333;font-size:10px;font-family:nanumgothic, Sans-serif;"><%=AddUtil.ChangeDate2(scd.getExt_dt())%></span></td>
	                                      </tr>
								<%}}%>
                        </table>
                <!-- 대여료 스케줄 -->
                    </td>
                </tr>
				<%if(tae_sum>0){%>
                <tr>
                    <td height=20><span style="color:#333333;font-size:11px;font-family:nanumgothic, Sans-serif;">(회차에 b가 표시된 것은 <%if(String.valueOf(base.get("CAR_NO")).equals(taecha.getCar_no())){%>만기매칭대차<%}else{%>출고전대차<%}%> 스케줄입니다.)</span></td>
                </tr>
				<%}%>
               	<tr>
                    <td height=30></td>
                </tr>
                <!-- 선납대여료균등발행 스케줄 2018.04.16 start -->
                <%if(fee_scd_sun_nap_size>0){%>
                <tr>
                    <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/bar_3_2.gif width=600 height=21><a href="<%=excel_down_link2%>"><img src=https://fms5.amazoncar.co.kr/acar/images/center/button_excel.gif border=0></a></td><!-- javascript:pop_excel('sn'); -->
                </tr>
                <tr>
                    <td height=5></td>
                </tr>
                <tr>
                    <td>
                        <table width=648 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                            <tr bgcolor=f2f2f2>
                                <td width=20 height=32 align=center><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">회차</span></td>
                                <td width=135 align=center><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">사용기간</span></td>
                                <td width=70 align=center><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">세금계산서<br>일자</span></td>
                                <td width=60 align=center><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">공급가</span></td>
                                <td width=50 align=center><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">부가세</span></td>
                                <td width=62 align=center><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">월대여료</span></td>
                                <td width=62 align=center><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">입금일자</span></td>
                                <td width=60 align=center><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">실입금액</span></td>
                                <td width=40 align=center><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">연체<br>일수</span></td>
                                <td width=50 align=center><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">연체료</span></td>
                                <td width=68 align=center><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">세금계산서<br>발행일자</span></td>
                            </tr>
                            <%-- <tr bgcolor=#FFFFFF>
                                <td colspan=10>
                                    <table width=646 border=0 cellspacing=0 cellpadding=0>
									<%
											for(int j = 0 ; j < fee_scd_sun_nap_size ; j++){
												FeeScdBean scd_sn = (FeeScdBean)fee_scd_sun_nap.elementAt(j);
												if(cls_chk.equals("Y") && !scd_sn.getTm_st1().equals("0") && scd_sn.getBill_yn().equals("N")) continue;												
									%>												
                                        <tr <%if(j%2 != 0){%>bgcolor=f7fae5<%}%>>
                                            <td width=21 height=23 align=center>
                                              <span style="color:#333333;font-family:nanumgothic, Sans-serif;font-size:11px;">
                                                <%if(scd_sn.getTm_st2().equals("2")){%>b<%}%>
                                                <%=scd_sn.getFee_tm()%>
                                              </span>
                                            </td><!-- 회차 -->
                                            <td width=136 align=center><span style="color:#333333;font-size:11px;font-family:nanumgothic, Sans-serif;">
											<%if(scd_sn.getTm_st1().equals("0")){%>
											<%=AddUtil.ChangeDate2(scd_sn.getUse_s_dt())%>~<%=AddUtil.ChangeDate2(scd_sn.getUse_e_dt())%>
											<%}else{%>
											잔액
											<%}%>
											</span></td><!-- 사용기간 -->
                                            <td width=71 align=center><span style="color:#6b930f;font-size:11px;font-family:nanumgothic, Sans-serif;"><%=AddUtil.ChangeDate2(scd_sn.getTax_out_dt())%></span></td><!-- 세금계산서 일자 -->
                                            <td width=61 align=right><span style="color:#333333;font-size:11px;font-family:nanumgothic, Sans-serif;"><%=Util.parseDecimal(scd_sn.getFee_s_amt())%></span>&nbsp;</td><!-- 공급가 -->
                                            <td width=51 align=right><span style="color:#333333;font-size:11px;font-family:nanumgothic, Sans-serif;"><%=Util.parseDecimal(scd_sn.getFee_v_amt())%></span>&nbsp;</td><!-- 부가세 -->
                                            <td width=76 align=right><span style="color:#6b930f;font-size:11px;font-family:nanumgothic, Sans-serif;"><b><%=Util.parseDecimal(scd_sn.getFee_s_amt()+scd_sn.getFee_v_amt())%></b> </span>&nbsp;</td><!-- 월대여료 -->
											<%if(scd_sn.getBill_yn().equals("Y")){%>
											<%		if( cls_chk.equals("Y") && scd_sn.getRc_dt().equals(AddUtil.replace(cls.getCls_dt(),"-","")) ){%>
                                        	<td width=61 align=center><span style="color:#333333;font-size:11px;font-family:nanumgothic, Sans-serif;"></span></td><!-- 입금일자 -->
                                        	<td width=76 align=right><span style="color:#6b930f;font-size:11px;font-family:nanumgothic, Sans-serif;"><b>0</b></span>&nbsp;</td><!-- 실입금액 -->
											<%		}else{%>
                                        	<td width=61 align=center><span style="color:#333333;font-size:11px;font-family:nanumgothic, Sans-serif;"><%=AddUtil.ChangeDate2(scd_sn.getRc_dt())%></span></td><!-- 입금일자 -->
                                        	<td width=76 align=right><span style="color:#6b930f;font-size:11px;font-family:nanumgothic, Sans-serif;"><b><%=Util.parseDecimal(scd_sn.getRc_amt())%></b></span>&nbsp;</td><!-- 실입금액 -->
											<%		}%>
											<%}else{%>
                                        	<td width=61 align=center><span style="color:#333333;font-size:11px;font-family:nanumgothic, Sans-serif;"><%if(cls_chk.equals("Y")){%><%}else{%><%=AddUtil.replace(cls.getCls_dt(),"-","")%><%}%></span></td>
                                        	<td width=76 align=right><span style="color:#6b930f;font-size:11px;font-family:nanumgothic, Sans-serif;"><b><%if(cls_chk.equals("Y")){%>0원<%}else{%>중도해지정산<%}%></b></span>&nbsp;</td><!-- 실입금액 -->
											<%}%>
                                        	<td width=41 align=center><span style="color:#333333;font-size:11px;font-family:nanumgothic, Sans-serif;"><%=scd_sn.getDly_days()%>일</span></td><!-- 연체일수 -->
                                        	<td width=52 align=right><span style="color:#333333;font-size:11px;font-family:nanumgothic, Sans-serif;"><%=Util.parseDecimal(scd_sn.getDly_fee())%></span>&nbsp;</td><!-- 연체료 -->
                                        	<td align=center><span style="color:#333333;font-size:10px;font-family:nanumgothic, Sans-serif;"><%=AddUtil.ChangeDate2(scd_sn.getExt_dt())%></span></td>
                                        </tr>
									<%}%>	
                                    </table>
                                </td>
                            </tr> --%>
                            <%
									for(int j = 0 ; j < fee_scd_sun_nap_size ; j++){
										FeeScdBean scd_sn = (FeeScdBean)fee_scd_sun_nap.elementAt(j);
										if(cls_chk.equals("Y") && !scd_sn.getTm_st1().equals("0") && scd_sn.getBill_yn().equals("N")) continue;												
							%>												
                                      <tr <%if(j%2 != 0){%>bgcolor=f7fae5<%}else{%>bgcolor=ffffff<%}%>>
                                          <td height=23 align=center>
                                            <span style="color:#333333;font-family:nanumgothic, Sans-serif;font-size:10px;">
                                              <%if(scd_sn.getTm_st2().equals("2")){%>b<%}%>
                                              <%=scd_sn.getFee_tm()%>
                                            </span>
                                          </td><!-- 회차 -->
                                          <td align=center><span style="color:#333333;font-size:11px;font-family:nanumgothic, Sans-serif;">
									<%if(scd_sn.getTm_st1().equals("0")){%>
									<%=AddUtil.ChangeDate2(scd_sn.getUse_s_dt())%>~<%=AddUtil.ChangeDate2(scd_sn.getUse_e_dt())%>
									<%}else{%>
									잔액
									<%}%>
									</span></td><!-- 사용기간 -->
                                          <td align=center><span style="color:#6b930f;font-size:10px;font-family:nanumgothic, Sans-serif;"><%=AddUtil.ChangeDate2(scd_sn.getTax_out_dt())%></span></td><!-- 세금계산서 일자 -->
                                          <td align=right><span style="color:#333333;font-size:10px;font-family:nanumgothic, Sans-serif;"><%=Util.parseDecimal(scd_sn.getFee_s_amt())%></span>&nbsp;</td><!-- 공급가 -->
                                          <td align=right><span style="color:#333333;font-size:10px;font-family:nanumgothic, Sans-serif;"><%=Util.parseDecimal(scd_sn.getFee_v_amt())%></span>&nbsp;</td><!-- 부가세 -->
                                          <td align=right><span style="color:#6b930f;font-size:10px;font-family:nanumgothic, Sans-serif;"><b><%=Util.parseDecimal(scd_sn.getFee_s_amt()+scd_sn.getFee_v_amt())%></b> </span>&nbsp;</td><!-- 월대여료 -->
									<%if(scd_sn.getBill_yn().equals("Y")){%>
									<%		if( cls_chk.equals("Y") && scd_sn.getRc_dt().equals(AddUtil.replace(cls.getCls_dt(),"-","")) ){%>
                                      	<td align=center><span style="color:#333333;font-size:10px;font-family:nanumgothic, Sans-serif;"></span></td><!-- 입금일자 -->
                                      	<td align=right><span style="color:#6b930f;font-size:10px;font-family:nanumgothic, Sans-serif;"><b>0</b></span>&nbsp;</td><!-- 실입금액 -->
									<%		}else{%>
                                      	<td align=center><span style="color:#333333;font-size:10px;font-family:nanumgothic, Sans-serif;"><%=AddUtil.ChangeDate2(scd_sn.getRc_dt())%></span></td><!-- 입금일자 -->
                                      	<td align=right><span style="color:#6b930f;font-size:10px;font-family:nanumgothic, Sans-serif;"><b><%=Util.parseDecimal(scd_sn.getRc_amt())%></b></span>&nbsp;</td><!-- 실입금액 -->
									<%		}%>
									<%}else{%>
                                      	<td align=center><span style="color:#333333;font-size:10px;font-family:nanumgothic, Sans-serif;"><%if(cls_chk.equals("Y")){%><%}else{%><%=AddUtil.replace(cls.getCls_dt(),"-","")%><%}%></span></td>
                                      	<td align=right><span style="color:#6b930f;font-size:10px;font-family:nanumgothic, Sans-serif;"><b><%if(cls_chk.equals("Y")){%>0원<%}else{%>중도해지정산<%}%></b></span>&nbsp;</td><!-- 실입금액 -->
									<%}%>
                                      	<td align=center><span style="color:#333333;font-size:10px;font-family:nanumgothic, Sans-serif;"><%=scd_sn.getDly_days()%>일</span></td><!-- 연체일수 -->
                                      	<td align=right><span style="color:#333333;font-size:10px;font-family:nanumgothic, Sans-serif;"><%=Util.parseDecimal(scd_sn.getDly_fee())%></span>&nbsp;</td><!-- 연체료 -->
                                      	<td align=center><span style="color:#333333;font-size:10px;font-family:nanumgothic, Sans-serif;"><%=AddUtil.ChangeDate2(scd_sn.getExt_dt())%></span></td>
                                      </tr>
							<%}%>
                        </table>
                    </td>
                </tr>
                <!-- 선납대여료균등발행 스케줄 2018.04.16 end -->
               	<tr>
                    <td height=30></td>
                </tr>
                <%}%>
                <tr>
                    <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/bar_5.gif width=648 height=21></td>
                </tr>
                <tr>
                    <td height=5></td>
                </tr>
                <tr>
                <!-- 대여료 통계 -->
                    <td>
                    	<table width=648 border=0 cellspacing=0 cellpadding=0>
                    		<tr>
                    			<td>
                                    <table width=428 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                                        <tr bgcolor=f2f2f2>
                                            <td width=74 align=center height=22><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">구분</span></td>
                                            <td width=64 align=center><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">건수</span></td>
                                            <td width=94 align=center><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">공급가</span></td>
                                            <td width=84 align=center><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">부가세</span></td>
                                            <td width=106 align=center><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">합계</span></td>
                                        </tr>
                                        <tr>
                                        	<td height=22 align=center bgcolor=f2f2f2><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">미수금</span></td>
                                      		<td align=right bgcolor=#FFFFFF><span style="color:#333333;font-family:nanumgothic, Sans-serif;font-size:11px;"><%=Util.parseDecimal(nc)%>건</span>&nbsp;</td>
                                     		<td align=right bgcolor=#FFFFFF><span style="color:#333333;font-family:nanumgothic, Sans-serif;font-size:11px;"><%=Util.parseDecimal(ns)%>원</span>&nbsp;</td>
                                   			<td align=right bgcolor=#FFFFFF><span style="color:#333333;font-family:nanumgothic, Sans-serif;font-size:11px;"><%=Util.parseDecimal(nv)%>원</span>&nbsp;</td>
                                     		<td align=right bgcolor=#FFFFFF><span style="color:#6b930f;font-family:nanumgothic, Sans-serif;font-size:11px;"><b><%=Util.parseDecimal(ns+nv)%>원</b></span>&nbsp;</td>
                                        </tr>
                                        <tr>
                                        	<td height=22 align=center bgcolor=f2f2f2><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">수금</span></td>
                                      		<td align=right bgcolor=#FFFFFF><span style="color:#333333;font-family:nanumgothic, Sans-serif;font-size:11px;"><%=Util.parseDecimal(rc)%>건</span>&nbsp;</td>
                                     		<td align=right bgcolor=#FFFFFF><span style="color:#333333;font-family:nanumgothic, Sans-serif;font-size:11px;"><%=Util.parseDecimal(rs)%>원</span>&nbsp;</td>
                                   			<td align=right bgcolor=#FFFFFF><span style="color:#333333;font-family:nanumgothic, Sans-serif;font-size:11px;"><%=Util.parseDecimal(rv)%>원</span>&nbsp;</td>
                                     		<td align=right bgcolor=#FFFFFF><span style="color:#6b930f;font-family:nanumgothic, Sans-serif;font-size:11px;"><b><%=Util.parseDecimal(rs+rv)%>원</b></span>&nbsp;</td>
                                        </tr>
                                        <tr>
                                        	<td height=22 align=center bgcolor=f2f2f2><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">미도래금</span></td>
                                      		<td align=right bgcolor=#FFFFFF><span style="color:#333333;font-family:nanumgothic, Sans-serif;font-size:11px;"><%=Util.parseDecimal(mc)%>건</span>&nbsp;</td>
                                     		<td align=right bgcolor=#FFFFFF><span style="color:#333333;font-family:nanumgothic, Sans-serif;font-size:11px;"><%=Util.parseDecimal(ms)%>원</span>&nbsp;</td>
                                   			<td align=right bgcolor=#FFFFFF><span style="color:#333333;font-family:nanumgothic, Sans-serif;font-size:11px;"><%=Util.parseDecimal(mv)%>원</span>&nbsp;</td>
                                     		<td align=right bgcolor=#FFFFFF><span style="color:#6b930f;font-family:nanumgothic, Sans-serif;font-size:11px;"><b><%=Util.parseDecimal(ms+mv)%>원</b></span>&nbsp;</td>
                                        </tr>
                                       <tr>
                                        	<td height=22 align=center bgcolor=f2f2f2><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">합계</span></td>
                                      		<td align=right bgcolor=#FFFFFF><span style="color:#333333;font-family:nanumgothic, Sans-serif;font-size:11px;"><%=Util.parseDecimal(nc+rc+mc)%>건</span>&nbsp;</td>
                                     		<td align=right bgcolor=#FFFFFF><span style="color:#333333;font-family:nanumgothic, Sans-serif;font-size:11px;"><%=Util.parseDecimal(ns+rs+ms)%>원</span>&nbsp;</td>
                                   			<td align=right bgcolor=#FFFFFF><span style="color:#333333;font-family:nanumgothic, Sans-serif;font-size:11px;"><%=Util.parseDecimal(nv+rv+mv)%>원</span>&nbsp;</td>
                                     		<td align=right bgcolor=#FFFFFF><span style="color:#6b930f;font-family:nanumgothic, Sans-serif;font-size:11px;"><b><%=Util.parseDecimal(ns+rs+ms+nv+rv+mv)%>원</b></span>&nbsp;</td>
                                        </tr>
                                    </table>
                                </td>
                                <td width=20>&nbsp;</td>
                                <td valign=top>
                                	<table width=200 border=0 cellpadding=0 cellspacing=1 bgcolor=c4c4c4>
                                		<tr>
                                			<td width=80 align=center bgcolor=f2f2f2 height=22><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">연체건수</span></td>
                                			<td bgcolor=ffffff align=right><span style="color:#333333;font-family:nanumgothic, Sans-serif;font-size:11px;"><%=Util.parseDecimal(String.valueOf(fee_stat.get("DC")))%>건</span>&nbsp;</td>
                                		</tr>
										<%	
											int dly_amt1 = AddUtil.parseInt(String.valueOf(fee_stat.get("DT")));
											int dly_amt2 = AddUtil.parseInt(String.valueOf(fee_stat.get("DT2")));
											int dly_amt3 = dly_amt1-dly_amt2;
										%>
                                		<tr>
                                			<td bgcolor=f2f2f2 align=center height=22><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">미수연체료</span></td>
                                			<td bgcolor=ffffff align=right><span style="color:#333333;font-family:nanumgothic, Sans-serif;font-size:11px;"><%=Util.parseDecimal(dly_amt3)%>원</span>&nbsp;</td>
                                		</tr>
                                		<tr>
                                			<td bgcolor=f2f2f2 align=center height=22><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">수금연체료</span></td>
                                			<td bgcolor=ffffff align=right><span style="color:#333333;font-family:nanumgothic, Sans-serif;font-size:11px;"><%=Util.parseDecimal(dly_amt2)%>원</span>&nbsp;</td>
                                		</tr>
                                		<tr>
                                			<td bgcolor=f2f2f2 align=center height=22><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">총연체료</span></td>
                                			<td bgcolor=ffffff align=right><span style="color:#333333;font-family:nanumgothic, Sans-serif;font-size:11px;"><%=Util.parseDecimal(dly_amt1)%>원</span>&nbsp;</td>
                                		</tr>
                                	</table>
                                </td>
                            </tr>
                            <%-- <%if (stamp_yn.equals("Y")) {%>
                            <tr>
                            	<td colspan="3" align="right">
                            		<img src="http://fms1.amazoncar.co.kr/mailing/rent/images/stamp.png" align="absmiddle" style="float: right; width: 80px;">
                            	</td>
                            </tr>
                            <%}%> --%>
                        </table>
                    </td>
                <!-- 대여료 통계 -->
                </tr>
                <tr>
                	<td height=30></td>
               	</tr>
         		<!-- 입금방법 : 무통장 -->
				<%if(cms.getRent_l_cd().equals("")){%>
                <tr>
                    <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/bar_4.gif width=648 height=21></td>
                </tr>
                <tr>
                    <td height=5></td>
                </tr>							
                <tr>
                    <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/bank.gif></td>
                </tr>
         		<!-- 입금방법 : 자동이체 -->							
				<%}else{%>
                <tr>
                    <td><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/bar_4_1.gif width=648 height=21></td>
                </tr>
                <tr>
                    <td height=5></td>
                </tr>							
                <tr>
                    <td>
                        <table width=648 border=0 cellpadding=0 cellspacing=0 bgcolor=f4f1e6>
                            <tr>
                                <td colspan=5><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/bank_up.gif width=648 height=4></td>
                            </tr>
                            <tr>
                                <td width=22>&nbsp;</td>
                                <td width=175><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/bank_1.gif width=175 height=109></td>
                                <td width=14>&nbsp;</td>
                                <td width=418>
                                    <table width=418 border=0 cellpadding=0 cellspacing=0 background=https://fms5.amazoncar.co.kr/mailing/rent/images/bank_c_bg.gif>
                                        <tr>
                                            <td colspan=5><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/bank_c_up.gif width=418 height=3></td>
                                        </tr>
                                        <tr>
                                            <td colspan=5 height=10></td>
                                        </tr>
                                        <tr>
                                            <td width=20 height=20>&nbsp;</td>
                                            <td width=12 align=left><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/dot.gif width=5 height=6></td>
                                            <td width=115 align=left><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">신청계좌 거래은행</span></td>
                                            <td width=20><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">|</span></td>
                                            <td width=251 align=left><span style="color:#333333;font-family:nanumgothic, Sans-serif;font-size:11px;"><%=cms.getCms_bank()%></span></td>
                                        </tr>
                                        <tr>
                                            <td height=20>&nbsp;</td>
                                            <td align=left><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/dot.gif width=5 height=6></td>
                                            <td align=left><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">신청계좌번호</span></td>
                                            <td><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">|</span></td>
                                            <td align=left><span style="color:#333333;font-family:nanumgothic, Sans-serif;font-size:11px;"><%=acc_no%></span></td>
                                        </tr>
                                        <tr>
                                            <td height=20>&nbsp;</td>
                                            <td align=left><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/dot.gif width=5 height=6></td>
                                            <td align=left><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">최초인출일자</span></td>
                                            <td><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">|</span></td>
                                            <td align=left><span style="color:#333333;font-family:nanumgothic, Sans-serif;font-size:11px;"><%=AddUtil.ChangeDate2(cms.getCms_start_dt())%></span></td>
                                        </tr>
                                        <tr>
                                            <td height=20>&nbsp;</td>
                                            <td align=left><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/dot.gif width=5 height=6></td>
                                            <td align=left><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">마지막인출일자</span></td>
                                            <td><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">|</span></td>
                                            <td align=left><span style="color:#333333;font-family:nanumgothic, Sans-serif;font-size:11px;"><%=AddUtil.ChangeDate2(cms.getCms_end_dt())%></span></td>
                                        </tr>
                                        <tr>
                                            <td height=20>&nbsp;</td>
                                            <td align=left><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/dot.gif width=5 height=6></td>
                                            <td align=left><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">이체일</span></td>
                                            <td><span style="color:#707166;font-family:nanumgothic, Sans-serif;font-size:11px;">|</span></td>
                                            <td align=left><span style="color:#e86e1b;font-family:nanumgothic, Sans-serif;font-size:11px;">매월 <%=cms.getCms_day()%>일</span></td>
                                        </tr>
                                        <tr>
                                            <td colspan=5 height=7></td>
                                        </tr>
                                        <tr>
                                            <td colspan=5><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/bank_c_dw.gif width=418 height=3></td>
                                        </tr>
                                    </table>
                                </td>
                                <td width=19>&nbsp;</td>
                            </tr>
                            <tr>
                                <td colspan=5><img src=https://fms5.amazoncar.co.kr/mailing/rent/images/bank_dw.gif width=648 height=4></td>
                            </tr>
                        </table>
                    </td>
                </tr>
				<%}%>							
         		<!-- 입금방법 -->
         		
                <%if (stamp_yn.equals("Y")) {%>
                <tr>
                    <td height=30></td>
                </tr>
                <tr>
                	<td align=center>
                		<!-- <div style="position: relative; text-align: center;">
					  		<font face="바탕" style="z-index: 1; font-size : 25px;"><b>주식회사 아마존카 대표이사 조&nbsp;성&nbsp;희</b></font>
					  		<img src="http://fms1.amazoncar.co.kr/mailing/rent/images/stamp.png" style="position:absolute; z-index: 2; left:520px; bottom: -23px; width: 80px;">
					  	</div> -->
				  		<!-- <img src="/mailing/rent/images/full_stamp.png"> -->
				  		<img src="https://fms5.amazoncar.co.kr/mailing/rent/images/full_stamp.png">
                	</td>
                </tr>
                <%}%>
                
                <tr>
                    <td height=15></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height=30 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif><img src=https://fms5.amazoncar.co.kr/mailing/images/line.gif width=667 height=1></td>
    </tr>
    <tr>
        <td height=20 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif style="font-family:nanumgothic, Sans-serif;font-size:11px;">본 메일은 발신전용 메일이므로 궁금한 사항은 <a href=mailto:tax@amazoncar.co.kr><span style="font-size:11px;color:#af2f98;">수신메일(tax@amazoncar.co.kr)</span></a>로 보내주시기 바랍니다.</span></td>
    </tr>
    <tr>
        <td height=20 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td align=center background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif><img src=https://fms5.amazoncar.co.kr/mailing/images/line.gif width=667 height=1></td>
    </tr>
    <tr>
        <td height=20 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>&nbsp;</td>
    </tr>
    <tr>
        <td background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif>
            <table width=700 border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td width=35>&nbsp;</td>
                    <td width=82><img src=https://fms5.amazoncar.co.kr/acar/images/logo_1.png></td>
                    <td width=28>&nbsp;</td>
                    <td width=1 bgcolor=dbdbdb></td>
                    <td width=32>&nbsp;</td>
                    <td width=523><img src=https://fms5.amazoncar.co.kr/mailing/images/bottom_esti_right.gif border=0></td>
                </tr>
                <map name=Map1>
                    <area shape=rect coords=283,53,403,67 href=mailto:tax@amazoncar.co.kr>
                </map>
            </table>
        </td>
    </tr>
    <tr>
        <td height=10 background=https://fms5.amazoncar.co.kr/mailing/images/layout_bg.gif></td>
    </tr>
    <tr>
        <td><img src=https://fms5.amazoncar.co.kr/mailing/images/layout_bottom.gif width=700 height=21></td>
    </tr>
</table>
<form name="form1" method="post"><!-- 2018.04.09 -->
	<input type="hidden" name="m_id" value="<%=m_id%>">
	<input type="hidden" name="l_cd" value="<%=l_cd%>">
	<input type="hidden" name="rent_st" value="<%=rent_st%>">
	<input type="hidden" name="b_dt" value="<%=b_dt%>">
	<input type="hidden" name="mode" value="<%=mode%>">
	<input type="hidden" name="bill_yn" value="<%=bill_yn%>">
	<input type="hidden" name="cls_chk" value="<%=cls_chk%>">
	<input type="hidden" name="rst" value="<%=rst%>">
	<input type="hidden" name="rst_full_size" value="<%=rst_full_size%>">
</form>
<!-- <script>
//리스트 엑셀 전환		2018.04.09
function pop_excel(gubun){
	var fm = document.form1;
	fm.target = "_blank";
	if(gubun=="sn"){
		fm.action = "scd_info_sn_excel.jsp";	
	}else{
		fm.action = "scd_info_excel.jsp";
	}
	fm.submit();
}
</script> -->
</body>
</html>