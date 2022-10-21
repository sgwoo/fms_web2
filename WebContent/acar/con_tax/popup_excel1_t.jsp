<%@ page language="java" contentType="text/plain;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.con_tax.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.con_tax.TaxDatabase"/>
<%
//개별소비세 전자문서 변환 페이지 .... 편집은 DesyEdit 프로그램 추천. FMS에서 파일을 TEXT로 저장받은 다음 Edit 프로그램으로 열어서 빈 첫3줄을 지우고 저장. 암호화 프로그램을 써서 파일을 암호화 시킨다.
response.setHeader("Content-Type", "text/plain");
response.setHeader("Content-Disposition", "attachment;filename="+AddUtil.ChangeString(AddUtil.getDate())+".401;");
String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
String gubun1 = request.getParameter("gubun1")==null?"13":request.getParameter("gubun1");
String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
String nb_dt = request.getParameter("nb_dt")==null?"":request.getParameter("nb_dt");
String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
String est_mon = request.getParameter("est_mon")==null?"":request.getParameter("est_mon");
String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");

String view_dt = "";
int total_su = 0;
long total_amt11 = 0;
long total_amt12 = 0;
long total_amt13 = 0;
long total_amt14 = 0;
long total_amt15 = 0;
long total_amt21 = 0;
long total_amt22 = 0;
long total_amt23 = 0;
long total_amt24 = 0;
long total_amt25 = 0;
long total_amt31 = 0;
long total_amt32 = 0;
long total_amt33 = 0;
long total_amt34 = 0;
long total_amt35 = 0;
long total_amt41 = 0;
long total_amt42 = 0;
long total_amt43 = 0;
long total_amt44 = 0;
long total_amt45 = 0;
String tax_rate1 = "";

Vector taxs1 = t_db.getTaxExcelList1_1(br_id, gubun1, gubun2, gubun3, "", gubun5, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc, "3");
int tax_size1 = taxs1.size();
if(tax_size1 > 0){
for(int i = 0 ; i < tax_size1 ; i++){
Hashtable tax1 = (Hashtable)taxs1.elementAt(i);
total_amt11   = total_amt11 + Long.parseLong(String.valueOf(tax1.get("CAR_FS_AMT")));
total_amt12   = total_amt12 + Long.parseLong(String.valueOf(tax1.get("과세표준")));
total_amt13   = total_amt13 + Long.parseLong(String.valueOf(tax1.get("산출개별소비세")));
total_amt14   = total_amt14 + Long.parseLong(String.valueOf(tax1.get("산출교육세")));
total_amt15   = total_amt15 + Long.parseLong(String.valueOf(tax1.get("AMT")));
tax_rate1 = (String)tax1.get("TAX_RATE");
}}
Vector taxs2 = t_db.getTaxExcelList1_1(br_id, gubun1, gubun2, gubun3, "", gubun5, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc, "2");
int tax_size2 = taxs2.size();
if(tax_size2 > 0){
for(int i = 0 ; i < tax_size2 ; i++){
Hashtable tax2 = (Hashtable)taxs2.elementAt(i);
total_amt21   = total_amt21 + Long.parseLong(String.valueOf(tax2.get("CAR_FS_AMT")));
total_amt22   = total_amt22 + Long.parseLong(String.valueOf(tax2.get("과세표준")));
total_amt23   = total_amt23 + Long.parseLong(String.valueOf(tax2.get("산출개별소비세")));
total_amt24   = total_amt24 + Long.parseLong(String.valueOf(tax2.get("산출교육세")));
total_amt25   = total_amt25 + Long.parseLong(String.valueOf(tax2.get("AMT")));
}}
Vector taxs3 = t_db.getTaxExcelList1_1(br_id, gubun1, gubun2, gubun3, "", gubun5, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc, "1");
int tax_size3 = taxs3.size();
if(tax_size3 > 0){
for(int i = 0 ; i < tax_size3 ; i++){
Hashtable tax3 = (Hashtable)taxs3.elementAt(i);
total_amt31   = total_amt31 + Long.parseLong(String.valueOf(tax3.get("CAR_FS_AMT")));
total_amt32   = total_amt32 + Long.parseLong(String.valueOf(tax3.get("과세표준")));
total_amt33   = total_amt33 + Long.parseLong(String.valueOf(tax3.get("산출개별소비세")));
total_amt34   = total_amt34 + Long.parseLong(String.valueOf(tax3.get("산출교육세")));
total_amt35   = total_amt35 + Long.parseLong(String.valueOf(tax3.get("AMT")));
}}
Vector taxs4 = t_db.getTaxExcelList1_1(br_id, gubun1, gubun2, gubun3, "", gubun5, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc, "4");
int tax_size4 = taxs4.size();
if(tax_size4 > 0){
for(int i = 0 ; i < tax_size4 ; i++){
Hashtable tax4 = (Hashtable)taxs4.elementAt(i);
total_amt41   = total_amt41 + Long.parseLong(String.valueOf(tax4.get("CAR_FS_AMT")));
total_amt42   = total_amt42 + Long.parseLong(String.valueOf(tax4.get("과세표준")));
total_amt43   = total_amt43 + Long.parseLong(String.valueOf(tax4.get("산출개별소비세")));
total_amt44   = total_amt44 + Long.parseLong(String.valueOf(tax4.get("산출교육세")));
total_amt45   = total_amt45 + Long.parseLong(String.valueOf(tax4.get("AMT")));

}}
String gsgg_dt = ""; //과세기간년월 ex)201301
//분기별 과세기간 선택
if(nb_dt.equals("04")){
	gsgg_dt = AddUtil.getDate(1)+nb_dt;
}else if(nb_dt.equals("07")){
	gsgg_dt = AddUtil.getDate(1)+nb_dt;
}else if(nb_dt.equals("10")){
	gsgg_dt = (AddUtil.parseInt(AddUtil.getDate(1))-1)+nb_dt;
}else if(nb_dt.equals("01")){
	gsgg_dt = AddUtil.getDate(1)+nb_dt;
}

//System.out.println("gsgg_dt: "+gsgg_dt);
//개별소비세 Header 부분
out.print("10");								//자료구분 : 10
out.print("S401");								//서식코드 : S401
out.print(AddUtil.rpad("1288147957",13," "));	//납세자ID : 아마존카 사업자등록번호
out.print("47");								//세목구분코드 : 47
out.print("1");									//신고구분 : 1
out.print("8");									//납세작분 : 8
out.print(AddUtil.getDate(5));					//제출년월
out.print(gsgg_dt);					//과세기간년월
out.print(AddUtil.rpad("amazoncar1",20," "));	//사용자ID : amazoncar1
out.print(AddUtil.rpad("송인숙",27," "));			//세무대리인성명
out.print("000131");							//세무대리인관리번호-user_id 넣음
out.print(AddUtil.rpad("07082248014",14," "));	//세무대리인전화번호
out.print(AddUtil.rpad("(주)아마존카",25," "));		//상호(법인명)
out.print(AddUtil.rpad("서울시 영등포구 여의도동 17-3 삼환까뮤 8층",54," "));		//사업장소재지
out.print(AddUtil.rpad("027570802",14," "));						//사업장전화번호
out.print(AddUtil.rpad("조성희",27," "));								//성명(대표자명)
out.print(AddUtil.ChangeString(AddUtil.getDate()));					//작성일자
out.print("9000");													//세무프로그램코드(9000-기타)
out.print("0001");													//신고차수
out.print("0001");													//순차번호
out.print(AddUtil.lpad(" ",31," "));								//공란
out.print("\n");													//다음줄로 넘김 enter 처리

//개별소비세 신고공통
out.print("41");								//자료구분
out.print("S401");								//서식코드
out.print("47");								//세목구분코드
out.print(gsgg_dt);								//과세기간년월
out.print(AddUtil.rpad("1288147957",13," "));	//납세자ID 
out.print("1");									//신고구분
out.print("0001");								//신고차수
out.print("0001");								//순차번호
out.print("8");									//납세자구분
out.print(AddUtil.rpad("amazoncar1",20," "));		//사용자ID
out.print("1156110019610");							//(주민)법인번호
out.print(AddUtil.ChangeString(AddUtil.getDate()));		//입력일자
out.print(AddUtil.getDate(5));							//제출년월
out.print(AddUtil.rpad("(주)아마존카",25," "));				//상호(법인명)
out.print(AddUtil.rpad("조성희",27," "));					//성명(대표자)
out.print(AddUtil.rpad("서울시 영등포구 여의도동 17-3 삼환까뮤 8층",54," "));	//사업장소재지
out.print(AddUtil.rpad("027570802",14," "));					//전화번호
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt13+total_amt23+total_amt33+total_amt43),15,"0"));	//납부할세액합계(개별소비세)
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt14+total_amt24+total_amt34+total_amt44),15,"0"));	//납부할세액합계(교육세)
out.print(AddUtil.lpad("0",15,"0"));															//납부할세액합계(농특세)
out.print(AddUtil.lpad(" ",8," "));																//페업일자
out.print(AddUtil.lpad(" ",70," "));															//폐업사유
out.print("N");																					//특례신청사업자여부 = N
out.print(AddUtil.lpad(" ",98," "));															//공안
out.print("\n");								//다음줄로 넘김 enter 처리

//과세물품과세표준신고서 51011, 50121 2000 이상, 이하 2가지 신고라서 각각의 합계까지 포함해서 총 4줄로 작성.
out.print("47");
out.print("S401");
out.print(AddUtil.rpad(" ",13," "));
out.print("00000");
out.print("51041");//51011
out.print("0000");
out.print(AddUtil.rpad("조건부면세용도위반승용차(2000CC초과)(18-1-3)",46," "));//일반승용자동차(2000cc초과)51
out.print(AddUtil.lpad("자동차",27," "));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt12),15,"0"));
out.print(AddUtil.lpad(tax_rate1,7,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt13),13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt14),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt13),13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt14),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print("0001");
out.print("0001");
out.print(AddUtil.lpad(" ",28," "));
out.print("\n");

//과세물품과세표준신고서 51021 부분
out.print("47");
out.print("S401");
out.print(AddUtil.rpad(" ",13," "));
out.print("00000");
out.print("51042");//51021
out.print("0000");
out.print(AddUtil.rpad("조건부용도위반승용차(2000CC이하)(2011년귀속부터)18-1-3",43," "));//일반승용자동차(2000cc이하)
out.print(AddUtil.lpad("자동차",27," "));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt22+total_amt32),15,"0"));
out.print("0000500");
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt23+total_amt33),13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt24+total_amt34),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt23+total_amt33),13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt24+total_amt34),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print("0001");
out.print("0001");
out.print(AddUtil.lpad(" ",28," "));
out.print("\n");

//과세물품과세표준신고서 51045 부분
out.print("47");
out.print("S401");
out.print(AddUtil.rpad(" ",13," "));
out.print("00000");
out.print("51045");//51045
out.print("0000");
out.print(AddUtil.rpad("조건부면세용도위반 하이브리드 2,000cc 초과",44," "));//일반승용자동차(2000cc초과)51
out.print(AddUtil.lpad("자동차",27," "));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt42),15,"0"));
out.print(AddUtil.lpad(tax_rate1,7,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt43),13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt44),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt43),13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt44),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print("0001");
out.print("0001");
out.print(AddUtil.lpad(" ",28," "));
out.print("\n");

//과세물품과세표준신고서 51041 합계 부분
out.print("47");
out.print("S401");
out.print(AddUtil.rpad(" ",13," "));
out.print("99999");
out.print("51041");//51041
out.print("0000");
out.print(AddUtil.rpad("조건부면세용도위반승용차(2000CC초과)(18-1-3)",46," "));//일반승용자동차(2000cc초과)51
out.print(AddUtil.lpad("자동차",27," "));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt12),15,"0"));
out.print(AddUtil.lpad(tax_rate1,7,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt13),13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt14),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt13),13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt14),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print("0001");
out.print("0001");
out.print(AddUtil.lpad(" ",28," "));
out.print("\n");

//과세물품과세표준신고서 51042 합계 부분
out.print("47");
out.print("S401");
out.print(AddUtil.rpad(" ",13," "));
out.print("99999");
out.print("51042");//51042
out.print("0000");
out.print(AddUtil.rpad("조건부용도위반승용차(2000CC이하)(2011년귀속부터)18-1-3",43," "));//일반승용자동차(2000cc이하)51
out.print(AddUtil.lpad("자동차",27," "));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt22+total_amt32),15,"0"));
out.print("0000500");
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt23+total_amt33),13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt24+total_amt34),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt23+total_amt33),13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt24+total_amt34),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print("0001");
out.print("0001");
out.print(AddUtil.lpad(" ",28," "));
out.print("\n");

//과세물품과세표준신고서 51045 합계 부분
out.print("47");
out.print("S401");
out.print(AddUtil.rpad(" ",13," "));
out.print("99999");
out.print("51045");//51045
out.print("0000");
out.print(AddUtil.rpad("조건부면세용도위반 하이브리드 2,000cc 초과",44," "));//하이브리드(2000cc초과)
out.print(AddUtil.lpad("자동차",27," "));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt42),15,"0"));
out.print(AddUtil.lpad(tax_rate1,7,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt43),13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt44),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt43),13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt44),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print("0001");
out.print("0001");
out.print(AddUtil.lpad(" ",28," "));
out.print("\n");

//과세물품총판매(반출)명세서 시작 -------------------------------------------------------------------------
if(tax_size1 > 0){
for(int i = 0 ; i < tax_size1 ; i++){
Hashtable tax1 = (Hashtable)taxs1.elementAt(i);
out.print("47");
out.print("S404");
out.print(AddUtil.rpad(" ",13," "));
out.print("00000");
out.print("51041");//51011
out.print("0000");
out.print(String.format("%06d", i+1));
out.print(AddUtil.getReplace_dt(String.valueOf(tax1.get("TAX_COME_DT")))); //out.print((String)(tax1.get("반출일자")));
out.print(AddUtil.rpad("조건부면세용도위반승용차(2000CC초과)(18-1-3)",46," "));//일반승용자동차(2000cc초과)
out.print(AddUtil.rpad((String)(tax1.get("CAR_NO")),29," "));
out.print(AddUtil.rpad("0",30," "));
out.print(AddUtil.lpad("1",11,"0"));						//수량
out.print(AddUtil.lpad((String)tax1.get("CAR_FS_AMT"),13,"0"));//단가
out.print(AddUtil.lpad((String)tax1.get("CAR_FS_AMT"),13,"0"));//반출가격
out.print(AddUtil.lpad((String)tax1.get("과세표준"),13,"0"));//과세표준(개별소비세)
out.print(AddUtil.lpad((String)tax1.get("TAX_RATE"),7,"0"));
out.print(AddUtil.lpad((String)tax1.get("산출개별소비세"),13,"0"));
out.print(AddUtil.lpad((String)tax1.get("산출교육세"),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad((String)tax1.get("산출개별소비세"),13,"0"));
out.print(AddUtil.lpad((String)tax1.get("산출교육세"),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad(" ",30," "));
out.print(AddUtil.lpad(" ",13," "));
out.print(AddUtil.lpad(" ",20," "));
out.print(AddUtil.getReplace_dt(String.valueOf(tax1.get("TAX_COME_DT"))));
out.print("N");
out.print((String)(tax1.get("INIT_REG_DT")));
out.print((String)(tax1.get("용도변경일자")));
out.print("1");
out.print(AddUtil.lpad((String)tax1.get("SUR_RATE"),4,"0"));
out.print(AddUtil.rpad((String)(tax1.get("CAR_NUM")),30," "));
out.print("0001");
out.print("0001");
out.print(AddUtil.lpad(" ",76," "));
out.print("\n");
}}
if(tax_size2 > 0){
for(int i = 0 ; i < tax_size2 ; i++){
Hashtable tax2 = (Hashtable)taxs2.elementAt(i);
out.print("47");
out.print("S404");
out.print(AddUtil.rpad(" ",13," "));
out.print("00000");
out.print("51042");//51021
out.print("0000");
out.print(String.format("%06d", tax_size1+i+1));
out.print(AddUtil.getReplace_dt(String.valueOf(tax2.get("TAX_COME_DT"))));//out.print((String)(tax2.get("반출일자")));
out.print(AddUtil.rpad("조건부용도위반승용차(2000CC이하)(2011년귀속부터)18-1-3",43," "));//일반승용자동차(2000cc이하)
out.print(AddUtil.rpad((String)(tax2.get("CAR_NO")),29," "));
out.print(AddUtil.rpad("0",30," "));
out.print(AddUtil.lpad("1",11,"0"));
out.print(AddUtil.lpad((String)tax2.get("CAR_FS_AMT"),13,"0"));
out.print(AddUtil.lpad((String)tax2.get("CAR_FS_AMT"),13,"0"));
out.print(AddUtil.lpad((String)tax2.get("과세표준"),13,"0"));
out.print(AddUtil.lpad((String)tax2.get("TAX_RATE"),7,"0"));
out.print(AddUtil.lpad((String)tax2.get("산출개별소비세"),13,"0"));
out.print(AddUtil.lpad((String)tax2.get("산출교육세"),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad((String)tax2.get("산출개별소비세"),13,"0"));
out.print(AddUtil.lpad((String)tax2.get("산출교육세"),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad(" ",30," "));
out.print(AddUtil.lpad(" ",13," "));
out.print(AddUtil.lpad(" ",20," "));
out.print(AddUtil.getReplace_dt(String.valueOf(tax2.get("TAX_COME_DT"))));
out.print("N");
out.print((String)(tax2.get("INIT_REG_DT")));
out.print((String)(tax2.get("용도변경일자")));
out.print("1");
out.print(AddUtil.lpad((String)tax2.get("SUR_RATE"),4,"0"));
out.print(AddUtil.rpad((String)(tax2.get("CAR_NUM")),30," "));
out.print("0001");
out.print("0001");
out.print(AddUtil.lpad(" ",76," "));
out.print("\n");
}}
if(tax_size3 > 0){
for(int i = 0 ; i < tax_size3 ; i++){
Hashtable tax3 = (Hashtable)taxs3.elementAt(i);
out.print("47");
out.print("S404");
out.print(AddUtil.rpad(" ",13," "));
out.print("00000");
out.print("51042");//51021
out.print("0000");
out.print(String.format("%06d", tax_size2+tax_size1+i+1));
out.print(AddUtil.getReplace_dt(String.valueOf(tax3.get("TAX_COME_DT"))));//out.print((String)(tax3.get("반출일자")));
out.print(AddUtil.rpad("조건부용도위반승용차(2000CC이하)(2011년귀속부터)18-1-3",43," "));//일반승용자동차(2000cc이하)
out.print(AddUtil.rpad((String)(tax3.get("CAR_NO")),29," "));
out.print(AddUtil.rpad("0",30," "));
out.print(AddUtil.lpad("1",11,"0"));
out.print(AddUtil.lpad((String)tax3.get("CAR_FS_AMT"),13,"0"));
out.print(AddUtil.lpad((String)tax3.get("CAR_FS_AMT"),13,"0"));
out.print(AddUtil.lpad((String)tax3.get("과세표준"),13,"0"));
out.print(AddUtil.lpad((String)tax3.get("TAX_RATE"),7,"0"));
out.print(AddUtil.lpad((String)tax3.get("산출개별소비세"),13,"0"));
out.print(AddUtil.lpad((String)tax3.get("산출교육세"),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad((String)tax3.get("산출개별소비세"),13,"0"));
out.print(AddUtil.lpad((String)tax3.get("산출교육세"),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad(" ",30," "));
out.print(AddUtil.lpad(" ",13," "));
out.print(AddUtil.lpad(" ",20," "));
out.print(AddUtil.getReplace_dt(String.valueOf(tax3.get("TAX_COME_DT"))));
out.print("N");
out.print((String)(tax3.get("INIT_REG_DT")));
out.print((String)(tax3.get("용도변경일자")));
out.print("1");
out.print(AddUtil.lpad((String)tax3.get("SUR_RATE"),4,"0"));
out.print(AddUtil.rpad((String)(tax3.get("CAR_NUM")),30," "));
out.print("0001");
out.print("0001");
out.print(AddUtil.lpad(" ",76," "));
out.print("\n");
}}
if(tax_size4 > 0){
for(int i = 0 ; i < tax_size4 ; i++){
Hashtable tax4 = (Hashtable)taxs4.elementAt(i);
out.print("47");
out.print("S404");
out.print(AddUtil.rpad(" ",13," "));
out.print("00000");
out.print("51045");//51045  6%/10000000
out.print("0000");
out.print(String.format("%06d", tax_size3+tax_size2+tax_size1+i+1));
out.print((String)(tax4.get("반출일자")));//out.print(AddUtil.getReplace_dt(String.valueOf(tax4.get("TAX_COME_DT"))));//
out.print(AddUtil.rpad("조건부면세용도위반 하이브리드 2,000cc 초과",44," "));//일반승용자동차(2000cc초과)
out.print(AddUtil.rpad((String)(tax4.get("CAR_NO")),29," "));
out.print(AddUtil.rpad("0",30," "));
out.print(AddUtil.lpad("1",11,"0"));						//수량
out.print(AddUtil.lpad((String)tax4.get("CAR_FS_AMT"),13,"0"));//단가
out.print(AddUtil.lpad((String)tax4.get("CAR_FS_AMT"),13,"0"));//반출가격
out.print(AddUtil.lpad((String)tax4.get("과세표준"),13,"0"));//과세표준(개별소비세)
out.print(AddUtil.lpad((String)tax4.get("TAX_RATE"),7,"0"));
out.print(AddUtil.lpad((String)tax4.get("산출개별소비세"),13,"0"));
out.print(AddUtil.lpad((String)tax4.get("산출교육세"),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad((String)tax4.get("산출개별소비세"),13,"0"));
out.print(AddUtil.lpad((String)tax4.get("산출교육세"),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad(" ",30," "));
out.print(AddUtil.lpad(" ",13," "));
out.print(AddUtil.lpad(" ",20," "));
out.print(AddUtil.getReplace_dt(String.valueOf(tax4.get("TAX_COME_DT"))));
out.print("N");
out.print((String)(tax4.get("INIT_REG_DT")));
out.print((String)(tax4.get("용도변경일자")));
out.print("1");
out.print(AddUtil.lpad((String)tax4.get("SUR_RATE"),4,"0"));
out.print(AddUtil.rpad((String)(tax4.get("CAR_NUM")),30," "));
out.print("0001");
out.print("0001");
out.print(AddUtil.lpad(" ",76," "));
out.print("\n");
}}
//과세물품총판매(반출)명세서 끝 -------------------------------------------------------------------------

//과세물품총판매(반출)명세서 합계부분  -------------------------------------------------------------------------
out.print("47");
out.print("S404");
out.print(AddUtil.rpad(" ",13," "));
out.print("99999");
out.print("99999");
out.print("9999");
out.print("000001");
out.print(AddUtil.ChangeString(AddUtil.getDate()));
out.print(AddUtil.rpad("합계",58," "));
out.print(AddUtil.rpad("자동차",27," "));
out.print(AddUtil.rpad("대",29," "));
out.print(String.format("%011d", 1));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt12+total_amt22+total_amt32+total_amt42),13,"0"));
out.print("0000000");
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt13+total_amt23+total_amt33+total_amt43),13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt14+total_amt24+total_amt34+total_amt44),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt13+total_amt23+total_amt33+total_amt43),13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt14+total_amt24+total_amt34+total_amt44),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad(" ",30," "));
out.print(AddUtil.lpad(" ",13," "));
out.print(AddUtil.lpad(" ",20," "));
out.print(AddUtil.lpad(" ",8," "));
out.print("N");
out.print(AddUtil.lpad(" ",8," "));
out.print(AddUtil.lpad(" ",8," "));
out.print("0");
out.print("0000");
out.print(AddUtil.lpad(" ",30," "));
out.print("0001");
out.print("0001");
out.print(AddUtil.lpad(" ",76," "));
out.print("\n");

/*
//제품수불상황표 시작 ------------------------------
if(tax_size1 > 0){
for(int i = 0 ; i < tax_size1 ; i++){
Hashtable tax1 = (Hashtable)taxs1.elementAt(i);
out.print("47");
out.print("S405");
out.print(AddUtil.rpad(" ",13," "));
out.print("00000");
out.print(String.format("%06d", i+1));
out.print(AddUtil.rpad((String)(tax1.get("CAR_NO")),29," "));
out.print(AddUtil.rpad("0",30," "));
out.print("대 ");
out.print(AddUtil.lpad("1",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("1",13,"0"));
out.print(AddUtil.lpad("1",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("1",13,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("1",15,"0"));
out.print(AddUtil.lpad("0",15,"0"));
out.print("0001");
out.print("0001");
out.print(AddUtil.lpad(" ",37," "));
out.print("\n");
}}
if(tax_size2 > 0){
for(int i = 0 ; i < tax_size2 ; i++){
Hashtable tax2 = (Hashtable)taxs2.elementAt(i);
out.print("47");
out.print("S405");
out.print(AddUtil.rpad(" ",13," "));
out.print("00000");
out.print(String.format("%06d", tax_size1+i+1));
out.print(AddUtil.rpad((String)(tax2.get("CAR_NO")),29," "));
out.print(AddUtil.rpad("0",30," "));
out.print("대 ");
out.print(AddUtil.lpad("1",11,"0"));out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("1",13,"0"));out.print(AddUtil.lpad("1",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));out.print(AddUtil.lpad("1",13,"0"));
out.print(AddUtil.lpad("0",11,"0"));out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("1",15,"0"));out.print(AddUtil.lpad("0",15,"0"));
out.print("0001");
out.print("0001");
out.print(AddUtil.lpad(" ",37," "));
out.print("\n");
}}
if(tax_size3 > 0){
for(int i = 0 ; i < tax_size3 ; i++){
Hashtable tax3 = (Hashtable)taxs3.elementAt(i);
out.print("47");
out.print("S405");
out.print(AddUtil.rpad(" ",13," "));
out.print("00000");
out.print(String.format("%06d", tax_size2+tax_size1+i+1));
out.print(AddUtil.rpad((String)(tax3.get("CAR_NO")),29," "));
out.print(AddUtil.rpad("0",30," "));
out.print("대 ");
out.print(AddUtil.lpad("1",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("1",13,"0"));
out.print(AddUtil.lpad("1",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("1",13,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("1",15,"0"));
out.print(AddUtil.lpad("0",15,"0"));
out.print("0001");
out.print("0001");
out.print(AddUtil.lpad(" ",37," "));
out.print("\n");
}}
//제품수불상황표  끝 -------------------------------------------------------------------
*/
out.close();


%>
